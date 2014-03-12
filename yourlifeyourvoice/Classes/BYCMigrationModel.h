#import <Foundation/Foundation.h>
#import "BYCDatabase.h"
#import "BYCQueue.h"

@interface BYCMigrationModel : NSObject
-(id)initWithDatabase:(BYCDatabase*)database queue:(BYCQueue*)queue;
+(BOOL)needsMigration:(BYCDatabase*)database;
-(void)performMigration:(void(^)())completion;

-(void)processEntries:(NSArray*)array intoDictionary:(NSMutableDictionary*)entries;
-(void)commitEntries:(NSDictionary*)entries;
@end
