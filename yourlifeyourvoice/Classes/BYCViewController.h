#import <UIKit/UIKit.h>
#import "BYCApplicationState.h"
#import "BYCNavigationView.h"
#import "BYCConstants.h"

#define BYCFlexibleView UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth

@interface BYCViewController : UIViewController<UIAlertViewDelegate>
@property (nonatomic, readonly) BYCApplicationState *applicationState;
@property (nonatomic, readonly) BYCNavigationView *navView;

-(id)initWithApplicationState:(BYCApplicationState*)applicationState;
-(void)setupMenuButton;
-(void)setupBackButton;

-(void)sidebarShown:(BOOL)shown animated:(BOOL)animated;
-(void)showError:(NSString*)title message:(NSString*)message;
-(void)showViewController:(BYCNotificationShowRootControllerType)type;
-(void)callYLYV;
@end
