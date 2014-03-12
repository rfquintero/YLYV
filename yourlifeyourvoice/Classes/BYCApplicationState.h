#import <Foundation/Foundation.h>
#import "BYCDatabase.h"
#import "BYCQueue.h"

@interface BYCApplicationState : NSObject
@property (nonatomic, readonly) BYCDatabase* database;
@property (nonatomic, readonly) BYCQueue *queue;
@property (nonatomic, readonly) BYCTouchBlocker *blocker;

-(id)initWithBlocker:(BYCTouchBlocker*)blocker;
@end
