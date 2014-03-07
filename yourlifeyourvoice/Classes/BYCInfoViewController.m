#import "BYCInfoViewController.h"
#import "BYCInfoView.h"

@interface BYCInfoViewController ()
@property (nonatomic) BYCInfoView *entryView;
@end

@implementation BYCInfoViewController

-(void)loadView {
    [super loadView];
    
    self.entryView = [[BYCInfoView alloc] initWithFrame:self.view.bounds];
    
    [self.navView setContentView:self.entryView];
    [self.navView setNavTitle:@"Your Life Your Voice"];
    [self setupMenuButton];
}

@end
