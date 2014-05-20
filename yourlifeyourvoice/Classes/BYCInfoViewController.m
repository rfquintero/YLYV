#import "BYCInfoViewController.h"
#import "BYCInfoView.h"

@interface BYCInfoViewController ()<BYCInfoViewDelegate>
@property (nonatomic) BYCInfoView *entryView;
@end

@implementation BYCInfoViewController

-(void)loadView {
    [super loadView];
    
    self.entryView = [[BYCInfoView alloc] initWithFrame:self.view.bounds];
    self.entryView.delegate = self;
    
    [self.navView setContentView:self.entryView];
    [self.navView setNavTitle:@""];
    [self setupMenuButton];
    
    self.screenName = @"Your Life Your Voice";
}

-(void)talkSelected {
    [self showViewController:BYCNotificationShowRootController_Talk];
}

-(void)siteSelected {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:BYCWebSite]];
}

@end
