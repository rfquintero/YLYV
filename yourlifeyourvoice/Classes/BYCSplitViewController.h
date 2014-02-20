#import <UIKit/UIKit.h>
#import "BYCApplicationState.h"

@interface BYCSplitViewController : UIViewController
-(id)initWithApplicationState:(BYCApplicationState*)applicationState;
-(void)setMainViewController:(UIViewController*)viewController;
@end
