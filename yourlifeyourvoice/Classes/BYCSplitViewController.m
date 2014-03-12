#import "BYCSplitViewController.h"
#import "BYCUI.h"
#import "BYCSideView.h"
#import "BYCConstants.h"
#import "BYCViewController.h"
#import "BYCTalkViewController.h"
#import "BYCEntryViewController.h"
#import "BYCEntriesViewController.h"
#import "BYCReportViewController.h"
#import "BYCReminderViewController.h"
#import "BYCTipsViewController.h"
#import "BYCInfoViewController.h"

#define kSidebarMargin 120

@interface BYCSplitViewController ()<BYCSideViewDelegate>
@property (nonatomic) BYCApplicationState *applicationState;
@property (nonatomic) UINavigationController *navController;
@property (nonatomic) BYCSideView *sideView;
@property (nonatomic) UIView *mainView;
@property (nonatomic) UIButton *touchBlocker;
@property (nonatomic, readwrite) BYCTouchBlocker *blocker;
@end

@implementation BYCSplitViewController

-(id)init {
    if(self = [super init]) {
        self.navController = [[UINavigationController alloc] init];
        self.blocker = [[BYCTouchBlocker alloc] initWithFrame:CGRectZero];
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
    
    self.blocker.frame = self.view.bounds;
    self.blocker.autoresizingMask = BYCFlexibleView;
    
    [self showSidebar:NO animated:NO];
    [self.view addSubview:self.mainView];
    [self.view addSubview:self.touchBlocker];
    [self.view addSubview:self.sideView];
    [self.view addSubview:self.blocker];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSidebar) name:BYCNotificationShowMenu object:self.navController];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showRootViewController:) name:BYCNotificationShowRootController object:self.navController];
}

-(void)setMainViewController:(UIViewController*)viewController {
    [self setMainViewController:viewController animated:NO];
}

-(void)setMainViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self.navController setViewControllers:@[viewController] animated:animated];
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

-(void)showRootViewController:(NSNotification*)notification {
    BYCNotificationShowRootControllerType type = [notification.userInfo[BYCNotificationShowRootControllerKey] intValue];
    NSNumber *moodType = notification.userInfo[BYCNotificationShowRootControllerMoodKey];
    switch (type) {
        case BYCNotificationShowRootController_Info:
            [self showViewController:[[BYCInfoViewController alloc] initWithApplicationState:self.applicationState] animated:YES];
            [self.sideView setSelectedMenuItem:BYCSideView_Info];
            break;
        case BYCNotificationShowRootController_Reports:
            [self showViewController:[[BYCReportViewController alloc] initWithApplicationState:self.applicationState] animated:YES];
            [self.sideView setSelectedMenuItem:BYCSideView_Reports];
            break;
        case BYCNotificationShowRootController_Reminder:
            [self showViewController:[[BYCReminderViewController alloc] initWithApplicationState:self.applicationState] animated:YES];
            [self.sideView setSelectedMenuItem:BYCSideView_Reminders];
            break;
        case BYCNotificationShowRootController_Talk:
            [self showViewController:[[BYCTalkViewController alloc] initWithApplicationState:self.applicationState] animated:YES];
            [self.sideView setSelectedMenuItem:BYCSideView_Talk];
            break;
        case BYCNotificationShowRootController_Tips: {
            BYCTipsViewController *vc = [[BYCTipsViewController alloc] initWithApplicationState:self.applicationState];
            vc.mood = moodType;
            [self showViewController:vc animated:YES];
            [self.sideView setSelectedMenuItem:BYCSideView_Tips];
            break;
        }
    }
}

-(void)showViewController:(UIViewController*)vc animated:(BOOL)animated {
    [self setMainViewController:vc animated:animated];
    [self hideSidebar];
}

-(void)entrySelected {
    [self showViewController:[[BYCEntryViewController alloc] initWithApplicationState:self.applicationState] animated:NO];
}

-(void)moodsSelected {
    [self showViewController:[[BYCEntriesViewController alloc] initWithApplicationState:self.applicationState] animated:NO];
}

-(void)talkSelected {
    [self showViewController:[[BYCTalkViewController alloc] initWithApplicationState:self.applicationState] animated:NO];
}

-(void)reportsSelected {
    [self showViewController:[[BYCReportViewController alloc] initWithApplicationState:self.applicationState] animated:NO];
}

-(void)reminderSelected {
    [self showViewController:[[BYCReminderViewController alloc] initWithApplicationState:self.applicationState] animated:NO];
}

-(void)tipsSelected {
    [self showViewController:[[BYCTipsViewController alloc] initWithApplicationState:self.applicationState] animated:NO];
}

-(void)infoSelected {
    [self showViewController:[[BYCInfoViewController alloc] initWithApplicationState:self.applicationState] animated:NO];
}

@end
