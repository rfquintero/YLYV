#import "BYCTalkViewController.h"
#import "BYCTalkView.h"

@interface BYCTalkViewController ()
@property (nonatomic) BYCTalkView *talkView;
@end

@implementation BYCTalkViewController

-(void)loadView {
    [super loadView];
    
    self.talkView = [[BYCTalkView alloc] initWithFrame:self.view.bounds];
//    self.talkView.delegate = self;
    
    [self.navView setContentView:self.talkView];
    [self.navView setNavTitle:@"Talk"];
    [self setupMenuButton];
}


@end
