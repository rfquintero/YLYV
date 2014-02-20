#import <UIKit/UIKit.h>
#import "BYCApplicationState.h"
#import "BYCNavigationView.h"

#define BYCFlexibleView UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth

@interface BYCViewController : UIViewController
@property (nonatomic, readonly) BYCApplicationState *applicationState;
@property (nonatomic, readonly) BYCNavigationView *navView;

-(id)initWithApplicationState:(BYCApplicationState*)applicationState;
@end
