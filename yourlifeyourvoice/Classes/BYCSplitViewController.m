#import "BYCSplitViewController.h"
#import "BYCUI.h"
#import "BYCSideView.h"
#import "BYCConstants.h"
#import "BYCViewController.h"
#import "BYCTalkViewController.h"
#import "BYCEntryViewController.h"

#define kSidebarMargin 120

@interface BYCSplitViewController ()<BYCSideViewDelegate>
@property (nonatomic) BYCApplicationState *applicationState;
@property (nonatomic) UINavigationController *navController;
@property (nonatomic) BYCSideView *sideView;
@property (nonatomic) UIView *mainView;
@property (nonatomic) UIButton *touchBlocker;
@end

@implementation BYCSplitViewController

-(id)initWithApplicationState:(BYCApplicationState*)applicationState {
    if(self = [super init]) {
        self.applicationState = applicationState;
        self.navController = [[UINavigationController alloc] init];
    }
    return self;
}

-(void)loadView {
    [super loadView];
    
    self.mainView = self.navController.view;
    self.mainView.frame = self.view.bounds;
    
    self.sideView = [[BYCSideView alloc] initWithFrame:CGRectZero];
    self.sideView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.sideView.delegate = self;
    
    self.touchBlocker = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.touchBlocker addTarget:self action:@selector(hideSidebar) forControlEvents:UIControlEventTouchUpInside];
    
    [self showSidebar:NO animated:NO];
    [self.view addSubview:self.mainView];
    [self.view addSubview:self.touchBlocker];
    [self.view addSubview:self.sideView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSidebar) name:BYCNotificationShowMenu object:self.navController];
}

-(void)setMainViewController:(UIViewController*)viewController {
    [self.navController setViewControllers:@[viewController] animated:NO];
}

-(void)layoutSidebarShown:(BOOL)show {
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    CGFloat sidebarWidth = width - kSidebarMargin;
    
    self.touchBlocker.hidden = !show;
    
    if(show) {
        self.sideView.frame = CGRectMake(kSidebarMargin, 0, sidebarWidth, height);
        self.touchBlocker.frame = CGRectMake(0, 0, kSidebarMargin, height);
        self.mainView.frame = CGRectMake(-sidebarWidth, 0, width, height);
    } else {
        self.sideView.frame = CGRectMake(width, 0, sidebarWidth, height);
        self.touchBlocker.frame = CGRectZero;
        self.mainView.frame = self.view.bounds;
    }
}

-(void)showSidebar:(BOOL)show animated:(BOOL)animated {
    [(BYCViewController*)[self.navController topViewController] sidebarShown:show animated:animated];
    if(animated) {
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutSidebarShown:show];
        }];
    } else {
        [self layoutSidebarShown:show];
    }
}

-(void)hideSidebar {
    [self showSidebar:NO animated:YES];
}

-(void)showSidebar {
    [self showSidebar:YES animated:YES];
}

-(void)showViewController:(UIViewController*)vc {
    self.mainViewController = vc;
    [self hideSidebar];
}

-(void)entrySelected {
    [self showViewController:[[BYCEntryViewController alloc] initWithApplicationState:self.applicationState]];
}

-(void)talkSelected {
    [self showViewController:[[BYCTalkViewController alloc] initWithApplicationState:self.applicationState]];
}

@end
