#import "BYCDatabase.h"
#import "BYCDatabaseUtilities.h"
#import "BYCEntry.h"

#define kSchemaVersion 2

@interface BYCDatabase()
@property (nonatomic) sqlite3* database;
@end

@implementation BYCDatabase
-(id)initWithDatabasePath:(NSString *)databasePath {
    if ((self = [super init])) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL databaseExists = [fileManager fileExistsAtPath:databasePath];
        sqlite3 *database = NULL;
        if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
            if (databaseExists) {
                int version = -1;
                const char *sql = "SELECT version FROM version";
                sqlite3_stmt *statement = NULL;
                sqlite3_prepare_v2(database, sql, -1, &statement, NULL);
                if (sqlite3_step(statement) == SQLITE_ROW) {
                    version = sqlite3_column_int(statement, 0);
                }
                sqlite3_finalize(statement);
                
                if (version != kSchemaVersion) {
                    [self performUpdateOnDatabase:database from:version to:kSchemaVersion];
                }
            } else {
                [self performCreate:database];
            }
        } else {
            sqlite3_close(database);
            database = NULL;
            NSLog(@"Failed to open cache database");
        }
        self.database = database;
    }
    return self;
}

-(void)dealloc {
    sqlite3_close(self.database);
    self.database = NULL;
}

-(void)performCreate:(sqlite3 *)database {
    sqlite3_execute(database, @"CREATE TABLE IF NOT EXISTS entries (type INTEGER, note TEXT, created_at INTEGER)");
    sqlite3_execute(database, @"CREATE TABLE IF NOT EXISTS reasons (reason TEXT, entry_id INTEGER NOT NULL)");
    sqlite3_execute(database, @"CREATE TABLE version (version INTEGER PRIMARY KEY)");
    sqlite3_execute(database, [NSString stringWithFormat:@"INSERT INTO version VALUES (%d)", kSchemaVersion]);
}

-(void)performUpdateOnDatabase:(sqlite3 *)database from:(int)oldVersion to:(int)newVersion {
    sqlite3_execute(database, @"DROP TABLE IF EXISTS entries");
    sqlite3_execute(database, @"DROP TABLE IF EXISTS reasons");
    sqlite3_execute(database, @"DROP TABLE IF EXISTS version");
    [self performCreate:database];
}

-(int64_t)saveWithType:(BYCMoodType)type notes:(NSString*)notes reasons:(NSArray*)reasons {
    static const char *sql = "INSERT INTO entries (type, note, created_at) VALUES (?, ?, ?)";
    sqlite3_stmt *statement = NULL;
    sqlite3_prepare_v2(self.database, sql, -1, &statement, NULL);
    sqlite3_bind_int(statement, 1, type);
    sqlite3_bind_string(statement, 2, notes);
    sqlite3_bind_int64(statement, 3, (int64_t)[NSDate timeIntervalSinceReferenceDate]);
    sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    int64_t uid = sqlite3_last_insert_rowid(self.database);
    for(NSString *reason in reasons) {
        static const char *reasonSql = "INSERT INTO reasons (reason, entry_id) VALUES (?,?)";
        sqlite3_stmt *stmt = NULL;
        sqlite3_prepare_v2(self.database, reasonSql, -1, &stmt, NULL);
        sqlite3_bind_string(stmt, 1, reason);
        sqlite3_bind_int64(stmt, 2, uid);
        sqlite3_step(stmt);
        sqlite3_finalize(stmt);
    }

    return uid;
}

-(BYCEntry*)getEntryWithUid:(int64_t)uid {
    NSMutableArray *reasons = [NSMutableArray array];
    BYCMoodType type;
    NSString *note;
    NSString *reason;
    int64_t date;
    
    static const char *sql = "SELECT entries.type, entries.note, entries.created_at, reasons.reason FROM entries LEFT OUTER JOIN reasons ON entries.rowid = reasons.entry_id WHERE entries.rowid = ?";
    sqlite3_stmt *statement = NULL;
    sqlite3_prepare_v2(self.database, sql, -1, &statement, NULL);
    sqlite3_bind_int64(statement, 1, uid);
    while(sqlite3_step(statement) == SQLITE_ROW) {
        type = sqlite3_column_int(statement, 0);
        note = sqlite3_column_string(statement, 1);
        date = sqlite3_column_int64(statement, 2);
        reason = sqlite3_column_string(statement, 3);
        if(reason) {
            [reasons addObject:reason];
        }
    }
    sqlite3_finalize(statement);
    reasons = reasons.count > 0 ? reasons : nil;
    
    return [BYCEntry entryWithId:uid type:type note:note reasons:reasons createdAt:[NSDate dateWithTimeIntervalSinceReferenceDate:date]];
}

-(NSArray*)getEntryPage:(NSInteger)page {
    NSMutableArray *entries = [NSMutableArray array];
    int limit = 20;
    int offset = (int)page*limit;
    
    static const char *sql = "SELECT rowid, type, note, created_at FROM entries ORDER BY rowid DESC LIMIT ? OFFSET ? ";
    sqlite3_stmt *statement = NULL;
    sqlite3_prepare_v2(self.database, sql, -1, &statement, NULL);
    sqlite3_bind_int(statement, 1, limit);
    sqlite3_bind_int(statement, 2, offset);
    while(sqlite3_step(statement) == SQLITE_ROW) {
        int64_t uid = sqlite3_column_int64(statement, 0);
        BYCMoodType type = sqlite3_column_int(statement, 1);
        NSString *note = sqlite3_column_string(statement, 2);
        int64_t date = sqlite3_column_int64(statement, 3);
        [entries addObject:[BYCEntry entryWithId:uid type:type note:note reasons:nil createdAt:[NSDate dateWithTimeIntervalSinceReferenceDate:date]]];
    }
    sqlite3_finalize(statement);

    return entries;
}

-(NSArray*)getAllEntries {
    NSMutableArray *entries = [NSMutableArray array];
    
    static const char *sql = "SELECT rowid, type FROM entries ORDER BY rowid DESC";
    sqlite3_stmt *statement = NULL;
    sqlite3_prepare_v2(self.database, sql, -1, &statement, NULL);
    while(sqlite3_step(statement) == SQLITE_ROW) {
        int64_t uid = sqlite3_column_int64(statement, 0);
        BYCMoodType type = sqlite3_column_int(statement, 1);
        NSString *note = sqlite3_column_string(statement, 2);
        int64_t date = sqlite3_column_int64(statement, 3);
        [entries addObject:[BYCEntry entryWithId:uid type:type note:note reasons:nil createdAt:[NSDate dateWithTimeIntervalSinceReferenceDate:date]]];
    }
    sqlite3_finalize(statement);
    
    return entries;

}

@end
