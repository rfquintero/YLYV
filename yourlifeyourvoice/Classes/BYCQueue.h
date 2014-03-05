#import <Foundation/Foundation.h>
#import "BYCTouchBlocker.h"

@interface BYCQueue : NSObject
-(id)initWithQueue:(NSOperationQueue*)queue blocker:(BYCTouchBlocker*)blocker;

-(void)performAsync:(void(^)())block callback:(void(^)())callback blocking:(BOOL)blocking;
@end
