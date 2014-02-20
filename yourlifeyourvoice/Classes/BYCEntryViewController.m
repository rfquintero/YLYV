#import "BYCEntryViewController.h"
#import "BYCEntryView.h"

@interface BYCEntryViewController ()
@property (nonatomic) BYCEntryView *entryView;
@end

@implementation BYCEntryViewController

-(void)loadView {
    [super loadView];
    
    self.entryView = [[BYCEntryView alloc] initWithFrame:self.view.bounds];
    [self.navView setContentView:self.entryView];
    [self.navView setNavTitle:@"I'm feeling..."];
    [self setupMenuButton];
}

@end
