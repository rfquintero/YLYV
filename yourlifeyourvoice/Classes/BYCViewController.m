#import "BYCViewController.h"
#import "BYCConstants.h"

@interface BYCViewController ()
@property (nonatomic, readwrite) BYCApplicationState *applicationState;
@property (nonatomic, readwrite) BYCNavigationView *navView;
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

-(void)showMenu {
    [[NSNotificationCenter defaultCenter] postNotificationName:BYCNotificationShowMenu object:self.navigationController];
}

@end
