#import <UIKit/UIKit.h>
#import "BYCApplicationState.h"

#define BYCFlexibleView UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth

@interface BYCViewController : UIViewController
@property (nonatomic, readonly) BYCApplicationState *applicationState;

-(id)initWithApplicationState:(BYCApplicationState*)applicationState;
@end
