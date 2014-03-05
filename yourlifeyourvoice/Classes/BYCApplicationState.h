#import <Foundation/Foundation.h>
#import "BYCDatabase.h"
#import "BYCQueue.h"

@interface BYCApplicationState : NSObject
@property (nonatomic, readonly) BYCDatabase* database;
@property (nonatomic, readonly) BYCQueue *queue;

-(id)initWithBlocker:(BYCTouchBlocker*)blocker;
@end
