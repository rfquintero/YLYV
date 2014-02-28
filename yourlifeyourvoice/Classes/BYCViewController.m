#import "BYCViewController.h"
#import "BYCConstants.h"

@interface BYCViewController ()<UIAlertViewDelegate>
@property (nonatomic, readwrite) BYCApplicationState *applicationState;
@property (nonatomic, readwrite) BYCNavigationView *navView;
@property (nonatomic) UIAlertView *alert;
@end

@implementation BYCViewController

-(id)initWithApplicationState:(BYCApplicationState*)applicationState {
    if(self = [super init]) {
        self.applicationState = applicationState;
    }
    return self;
}

-(void)loadView {
    [super loadView];
    self.navView = [[BYCNavigationView alloc] initWithFrame:self.view.bounds];
    self.navView.autoresizingMask = BYCFlexibleView;
    [self.view addSubview:self.navView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)setupMenuButton {
    [self.navView setupMenuButton:self action:@selector(showMenu)];
}

-(void)setupBackButton {
    [self.navView setupBackButton:self action:@selector(backSelected)];
}

-(void)backSelected {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showMenu {
    [[NSNotificationCenter defaultCenter] postNotificationName:BYCNotificationShowMenu object:self.navigationController];
}

-(void)sidebarShown:(BOOL)shown animated:(BOOL)animated {
    [self.navView setRightButtonHidden:shown animated:animated];
}

-(void)showError:(NSString*)title message:(NSString*)message {
    if(!self.alert) {
        self.alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [self.alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    self.alert = nil;
}

@end
