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
    
    BYCEntry *entry = entries[1];
    XCTAssertEqual(entry.uid, uid1);
    XCTAssertEqual(entry.type, BYCMood_Confused);
    XCTAssertEqualObjects(entry.note, @"This is a note.");
    
    entry = entries[0];
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

-(void)testWhenRecordIsUpdatedItCanBeRetrieved {
    int64_t uid1 = [testObject saveWithType:BYCMood_Invisible notes:@"This is a note." reasons:@[@"Reason 1", @"Reason 2"]];
    int64_t uid2 = [testObject saveWithType:BYCMood_Proud notes:@"No reasons." reasons:nil];
    int64_t uid3 = [testObject saveWithType:BYCMood_Angry notes:@"One reason." reasons:@[@"Hi"]];
    
    BYCEntry *entry1 = [testObject2 getEntryWithUid:uid1];
    BYCEntry *entry2 = [testObject2 getEntryWithUid:uid2];
    BYCEntry *entry3 = [testObject2 getEntryWithUid:uid3];
    
    [testObject updateEntry:entry1 notes:@"New note1" reasons:nil];
    [testObject updateEntry:entry2 notes:@"Whatever" reasons:@[@"New reason!"]];
    [testObject updateEntry:entry3 notes:@"New reasons." reasons:@[@"Hello", @"There"]];
    
    entry1 = [testObject2 getEntryWithUid:uid1];
    entry2 = [testObject2 getEntryWithUid:uid2];
    entry3 = [testObject2 getEntryWithUid:uid3];
    
    XCTAssertEqual(entry1.uid, uid1);
    XCTAssertEqual(entry1.type, BYCMood_Invisible);
    XCTAssertEqualObjects(entry1.note, @"New note1");
    XCTAssertNil(entry1.reasons);

    NSArray *reasons = @[@"New reason!"];
    XCTAssertEqual(entry2.uid, uid2);
    XCTAssertEqual(entry2.type, BYCMood_Proud);
    XCTAssertEqualObjects(entry2.note, @"Whatever");
    XCTAssertEqualObjects(entry2.reasons, reasons);
    
    reasons =  @[@"Hello", @"There"];
    XCTAssertEqual(entry3.uid, uid3);
    XCTAssertEqual(entry3.type, BYCMood_Angry);
    XCTAssertEqualObjects(entry3.note, @"New reasons.");
    XCTAssertEqualObjects(entry3.reasons, reasons);
}

-(void)testWhenEntryIsDeletedItCannotBeRetrieved {
    int64_t uid1 = [testObject saveWithType:BYCMood_Invisible notes:@"This is a note." reasons:@[@"Reason 1", @"Reason 2"]];
    
    BYCEntry *entry1 = [testObject2 getEntryWithUid:uid1];
    [testObject deleteEntry:entry1];
    
    XCTAssertNil([testObject2 getEntryWithUid:entry1.uid]);
}

-(void)testWhenReminderTimeIsSetThenItCanBeRetrieved {
    BYCReminderTime *time = [[BYCReminderTime alloc] init];
    [time setTimeWithHour:14 minute:30];
    time.active = YES;
    
    [testObject saveReminderTime:time];
    BYCReminderTime *time2 = [testObject2 getReminderTime];
    
    XCTAssertEqual(time.hour, time2.hour);
    XCTAssertEqual(time.minute, time2.minute);
    XCTAssertEqual(time.active, time2.active);
    XCTAssertEqualObjects(time.date, time2.date);
    XCTAssertEqualObjects(time.string, time2.string);
}

-(void)testWhenReminderIsUpdatedThenItCanBeRetrieved {
    BYCReminderTime *time = [[BYCReminderTime alloc] init];
    [time setTimeWithHour:14 minute:30];
    [testObject saveReminderTime:time];
    
    [time setTimeWithDate:[NSDate date]];
    time.active = NO;
    
    [testObject saveReminderTime:time];
    BYCReminderTime *time2 = [testObject2 getReminderTime];
    
    XCTAssertEqual(time.hour, time2.hour);
    XCTAssertEqual(time.minute, time2.minute);
    XCTAssertEqual(time.active, time2.active);
    XCTAssertEqualObjects(time.date, time2.date);
    XCTAssertEqualObjects(time.string, time2.string);
}

-(void)testWhenLaunchedIsSetThenItCanBeRetrieved {
    XCTAssertTrue([testObject isFirstLaunch]);
    
    [testObject2 setLaunched];
    XCTAssertFalse([testObject isFirstLaunch]);

    [testObject2 setLaunched];
    XCTAssertFalse([testObject isFirstLaunch]);
}

-(void)testWhenRatedIsSetThenItCanBeRetrieved {
    XCTAssertFalse([testObject isRated]);
    
    [testObject2 setLaunched];
    XCTAssertFalse([testObject isRated]);
    
    [testObject2 setRated];
    XCTAssertTrue([testObject isRated]);
    [testObject2 setRated];
    XCTAssertTrue([testObject isRated]);
}

@end
