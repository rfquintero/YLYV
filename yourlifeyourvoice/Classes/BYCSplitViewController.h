#import <UIKit/UIKit.h>
#import "BYCApplicationState.h"
#import "BYCTouchBlocker.h"

@interface BYCSplitViewController : UIViewController
@property (nonatomic, readonly) BYCTouchBlocker* blocker;

-(void)setApplicationState:(BYCApplicationState*)applicationState;
-(void)setMainViewController:(UIViewController*)viewController;
@end
