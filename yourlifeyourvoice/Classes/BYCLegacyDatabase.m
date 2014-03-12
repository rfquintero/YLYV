#import "BYCLegacyDatabase.h"
#import "BYCDatabaseUtilities.h"

@interface BYCLegacyEntry()
@property (nonatomic, readwrite) NSString *key;
@property (nonatomic, readwrite) NSString *value;
@end

@implementation BYCLegacyEntry
@end

@interface BYCLegacyDatabase()
@property (nonatomic) sqlite3* database;
@end

@implementation BYCLegacyDatabase
-(id)initWithDatabasePath:(NSString *)databasePath {
    if ((self = [super init])) {
        sqlite3 *database = NULL;
        if (sqlite3_open([databasePath UTF8String], &database) != SQLITE_OK) {
            sqlite3_close(database);
            database = NULL;
            NSLog(@"Failed to open cache database");
        }
        self.database = database;
    }
    return self;
}

-(NSArray*)getEntries {
    NSMutableArray *entries = [NSMutableArray array];
    
    static const char *sql = "SELECT key, value FROM ItemTable";
    sqlite3_stmt *statement = NULL;
    sqlite3_prepare_v2(self.database, sql, -1, &statement, NULL);
    while(sqlite3_step(statement) == SQLITE_ROW) {
        BYCLegacyEntry *entry = [[BYCLegacyEntry alloc] init];
        entry.key = sqlite3_column_string(statement, 0);
        entry.value = sqlite3_column_string(statement, 1);
        NSLog(@"ENTRY FOUND: %@ %@", entry.key, entry.value);
        [entries addObject:entry];
    }
    sqlite3_finalize(statement);
    
    return entries;
}
@end
