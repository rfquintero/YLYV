#import "BYCDatabase.h"
#import "BYCDatabaseUtilities.h"

#define kSchemaVersion 1

@interface BYCDatabase()
@property (nonatomic) sqlite3* database;
@end

@implementation BYCDatabase
- (id)initWithDatabasePath:(NSString *)databasePath {
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

- (void)dealloc {
    sqlite3_close(self.database);
    self.database = NULL;
}

- (void)performCreate:(sqlite3 *)database {
    sqlite3_execute(database, @"CREATE TABLE auth (token TEXT PRIMARY KEY)");
    sqlite3_execute(database, @"CREATE TABLE twitter (twitterId TEXT PRIMARY KEY)");
    sqlite3_execute(database, @"CREATE TABLE version (version INTEGER PRIMARY KEY)");
    sqlite3_execute(database, [NSString stringWithFormat:@"INSERT INTO version VALUES (%d)", kSchemaVersion]);
}

- (void)performUpdateOnDatabase:(sqlite3 *)database from:(int)oldVersion to:(int)newVersion {
    sqlite3_execute(database, @"DROP TABLE IF EXISTS auth");
    sqlite3_execute(database, @"DROP TABLE IF EXISTS twitter");
    sqlite3_execute(database, @"DROP TABLE IF EXISTS version");
    [self performCreate:database];
}


@end
