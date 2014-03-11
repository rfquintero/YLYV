#import <Foundation/Foundation.h>
#import "BYCEntry.h"
#import "BYCReminderTime.h"

@interface BYCDatabase : NSObject
-(id)initWithDatabasePath:(NSString *)databasePath;

-(int64_t)saveWithType:(BYCMoodType)type notes:(NSString*)notes reasons:(NSArray*)reasons;
-(BYCEntry*)getEntryWithUid:(int64_t)uid;
-(NSArray*)getEntryPage:(NSInteger)page;
-(NSArray*)getAllEntries;
-(void)updateEntry:(BYCEntry*)entry notes:(NSString*)notes reasons:(NSArray*)reasons;
-(void)deleteEntry:(BYCEntry*)entry;

-(void)saveReminderTime:(BYCReminderTime*)time;
-(BYCReminderTime*)getReminderTime;

-(void)setLaunched;
-(BOOL)isFirstLaunch;
@end