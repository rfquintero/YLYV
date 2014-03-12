#import <XCTest/XCTest.h>
#import "BYCLegacyDatabase.h"
#import "BYCMigrationModel.h"

@interface BYCLegacyEntry()
@property (nonatomic, readwrite) NSString *key;
@property (nonatomic, readwrite) NSString *value;
@end

@interface BYCLegacyTest : XCTestCase {
    BYCMigrationModel *testObject;
    NSMutableDictionary *entries;
    BYCDatabase *database;
}

@end

@implementation BYCLegacyTest

-(BYCLegacyEntry*)entryWithKey:(NSString*)key value:(NSString*)value {
    BYCLegacyEntry *entry = [[BYCLegacyEntry alloc] init];
    entry.key = key;
    entry.value = value;
    return entry;
}

-(BOOL)assertDate:(NSDate*)date onDay:(NSInteger)day month:(NSInteger)month year:(NSInteger)year {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:date];
    
    XCTAssertEqual(components.day, day);
    XCTAssertEqual(components.month, month);
    XCTAssertEqual(components.year, year);
}

- (void)setUp {
    [super setUp];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"test_database.sqlite"];
    [[NSFileManager defaultManager] removeItemAtPath:dbPath error:nil];
    database = [[BYCDatabase alloc] initWithDatabasePath:dbPath];
    
    testObject = [[BYCMigrationModel alloc] initWithDatabase:database queue:nil];
    entries = [NSMutableDictionary dictionary];
}

-(void)testWhenDuplicateEntriesExistThenOneWithLowestLexicalKeyIsKept {
    NSArray *array = @[[self entryWithKey:@"4" value:@"[\"Crazy JSON\",3]"],
                         [self entryWithKey:@"1" value:@"[\"Crazy JSON\",3]"],
                         [self entryWithKey:@"1" value:@"[\"Whatever\"]"]];
    
    [testObject processEntries:array intoDictionary:entries];
    
    XCTAssertTrue(entries.count == 2);
    XCTAssertEqualObjects(entries[@"[\"Crazy JSON\",3]"], array[1]);
    XCTAssertEqualObjects(entries[@"[\"Whatever\"]"], array[2]);
}

-(void)testWhenEntryHasNoValueIsItSkipped {
    NSArray *array = @[[self entryWithKey:@"4" value:nil],
                       [self entryWithKey:@"1" value:@"[\"Whatever\"]"]];
    [testObject processEntries:array intoDictionary:entries];
    
    XCTAssertTrue(entries.count == 1);
    XCTAssertEqualObjects(entries[@"[\"Whatever\"]"], array[1]);
}

-(void)testWhenEntriesAreCommitedThenValidEntriesAreSavedOrderedByDateAndKey {
    NSString *value1 = @"[\"Relieved\",\"Brother\",\"Words go here. Is there a limit to what I'm thinking?\",\"\",\"file://localhost/var/mobile/Applications/168D86E7-1296-4C7C-A00F-49B2851A6D10/Documents/photos/Titlefile.jpg\",\"11.16.2013\",1,\"Title\"]";
    NSString *value2 = @"[\"Lonely\",\"Parents\",\"These are words.\",\"/var/mobile/Applications/168D86E7-1296-4C7C-A00F-49B2851A6D10/Documents/recordingThis is a title.wav\",\"\",\"11.16.2013\",-1,\"This is a title\"]";
    NSString *value3 = @"[\"Frustrated\",\"Friends\",\"\",\"\",\"\",\"11.17.2013\",-1,\"Titles are required\"]";
    
    NSArray *array = @[[self entryWithKey:@"2" value:value2],
                       [self entryWithKey:@"2" value:@"Not a JSON array"],
                       [self entryWithKey:@"3" value:@"[\"too short\", 2, 2, 4, 5]"],
                       [self entryWithKey:@"1" value:value1],
                       [self entryWithKey:@"0" value:value3],
                       [self entryWithKey:@"4" value:@"<html><title>Blow up?</title></html>"]];

    [testObject processEntries:array intoDictionary:entries];
    [testObject commitEntries:entries];
    
    NSArray *migrated = [database getAllEntries];
    XCTAssertTrue(migrated.count == 3);
    
    BYCEntry *entry = [database getEntryWithUid:[migrated[2] uid]];
    XCTAssertEqual(entry.type, BYCMood_Relieved);
    XCTAssertEqualObjects(entry.note, @"Words go here. Is there a limit to what I'm thinking?");
    XCTAssertEqualObjects(entry.reasons, @[@"Brother"]);
    [self assertDate:entry.createdAt onDay:16 month:11 year:2013];
    
    entry = [database getEntryWithUid:[migrated[1] uid]];
    XCTAssertEqual(entry.type, BYCMood_Lonely);
    XCTAssertEqualObjects(entry.note, @"These are words.");
    XCTAssertEqualObjects(entry.reasons, @[@"Parents"]);
    [self assertDate:entry.createdAt onDay:16 month:11 year:2013];
    
    entry = [database getEntryWithUid:[migrated[0] uid]];
    XCTAssertEqual(entry.type, BYCMood_Frustrated);
    XCTAssertEqualObjects(entry.note, @"");
    XCTAssertEqualObjects(entry.reasons, @[@"Friends"]);
    [self assertDate:entry.createdAt onDay:17 month:11 year:2013];
}

@end
