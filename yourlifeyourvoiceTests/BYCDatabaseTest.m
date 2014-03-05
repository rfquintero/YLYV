#import <XCTest/XCTest.h>
#import "BYCDatabase.h"
#import "BYCEntry.h"

@interface BYCDatabaseTest : XCTestCase {
    BYCDatabase *testObject;
    BYCDatabase *testObject2;
}

@end

@implementation BYCDatabaseTest

-(void)setUp {
    [super setUp];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"test_database.sqlite"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    [fileManager removeItemAtPath:dbPath error:&error];
    
    testObject = [[BYCDatabase alloc] initWithDatabasePath:dbPath];
    testObject2 = [[BYCDatabase alloc] initWithDatabasePath:dbPath];
}

-(void)testWhenRecordIsSavedThenItIsAddedToTheEntries {
    NSArray *reasons = @[@"Reason 1", @"Reason 2"];
    int64_t uid1 = [testObject saveWithType:BYCMood_Confused notes:@"This is a note." reasons:reasons];
    int64_t uid2 = [testObject saveWithType:BYCMood_Happy notes:@"No reasons." reasons:nil];
    NSArray *entries = [testObject2 getEntryPage:0];
    
    XCTAssertTrue(entries.count == 2);
    
    BYCEntry *entry = entries[0];
    XCTAssertEqual(entry.uid, uid1);
    XCTAssertEqual(entry.type, BYCMood_Confused);
    XCTAssertEqualObjects(entry.note, @"This is a note.");
    
    entry = entries[1];
    XCTAssertEqual(entry.uid, uid2);
    XCTAssertEqual(entry.type, BYCMood_Happy);
    XCTAssertEqualObjects(entry.note, @"No reasons.");
}

-(void)testWhenRecordIsSavedThenItCanBeRetrieved {
    NSArray *reasons = @[@"Reason 1", @"Reason 2"];
    int64_t uid1 = [testObject saveWithType:BYCMood_Invisible notes:@"This is a note." reasons:reasons];
    int64_t uid2 = [testObject saveWithType:BYCMood_Proud notes:@"No reasons." reasons:nil];
    
    BYCEntry *entry = [testObject2 getEntryWithUid:uid1];
    XCTAssertEqual(entry.uid, uid1);
    XCTAssertEqual(entry.type, BYCMood_Invisible);
    XCTAssertEqualObjects(entry.note, @"This is a note.");
    XCTAssertEqualObjects(entry.reasons, reasons);
    
    entry = [testObject getEntryWithUid:uid2];
    XCTAssertEqual(entry.type, BYCMood_Proud);
    XCTAssertEqual(entry.uid, uid2);
    XCTAssertEqualObjects(entry.note, @"No reasons.");
    XCTAssertNil(entry.reasons);
}



@end
