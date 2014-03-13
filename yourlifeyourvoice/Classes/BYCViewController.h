#import <UIKit/UIKit.h>
#import "BYCApplicationState.h"
#import "BYCNavigationView.h"
#import "BYCConstants.h"
#import "GAI.h"

#define BYCFlexibleView UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth

@interface BYCViewController : GAITrackedViewController<UIAlertViewDelegate>
@property (nonatomic, readonly) BYCApplicationState *applicationState;
@property (nonatomic, readonly) BYCNavigationView *navView;

-(id)initWithApplicationState:(BYCApplicationState*)applicationState;
-(void)setupMenuButton;
-(void)setupBackButton;

-(void)sidebarShown:(BOOL)shown animated:(BOOL)animated;
-(void)showError:(NSString*)title message:(NSString*)message;
-(void)showViewController:(BYCNotificationShowRootControllerType)type;
-(void)showViewController:(BYCNotificationShowRootControllerType)type userInfo:(NSDictionary*)userInfo;
-(void)callYLYV;

-(void)trackEvent:(NSString*)category action:(NSString*)action label:(NSString*)label value:(NSNumber*)value;
@end
