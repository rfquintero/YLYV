#import <Foundation/Foundation.h>
#import "BYCEntry.h"

@interface BYCDatabase : NSObject
-(id)initWithDatabasePath:(NSString *)databasePath;
-(int64_t)saveWithType:(BYCMoodType)type notes:(NSString*)notes reasons:(NSArray*)reasons;
-(BYCEntry*)getEntryWithUid:(int64_t)uid;
-(NSArray*)getEntryPage:(NSInteger)page;
-(NSArray*)getAllEntries;
@end