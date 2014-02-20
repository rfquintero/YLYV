#import "BYCViewController.h"

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
    self.navView = [[BYCNavigationView alloc] initWithFrame:CGRectZero];
    self.navView.autoresizingMask = BYCFlexibleView;
    [self.view addSubview:self.navView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

@end
