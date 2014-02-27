#import "BYCEntryViewController.h"
#import "BYCEntryView.h"

@interface BYCEntryViewController ()<BYCEntryViewDelegate>
@property (nonatomic) BYCEntryView *entryView;
@end

@implementation BYCEntryViewController

-(void)loadView {
    [super loadView];
    
    self.entryView = [[BYCEntryView alloc] initWithFrame:self.view.bounds];
    self.entryView.delegate = self;
    
    [self.navView setContentView:self.entryView];
    [self.navView setNavTitle:@"I'm feeling..."];
    [self.navView setupBackButton:self action:@selector(backSelected)];
    [self.navView setLeftButtonHidden:YES animated:NO];
    [self.entryView setNavView:self.navView];
    [self setupMenuButton];
}

#pragma mark BYCEntryViewDelegate

-(void)photoSelected {
    
}

-(void)becauseSelected {
    
}

-(void)audioSelected {
    
}

-(void)saveSelected {
    
}

-(void)deleteSelected {
    
}

-(void)entryStarted {
    [self.navView setLeftButtonHidden:NO animated:YES];
    [self.navView setNavTitleHidden:YES animated:YES];
}

-(void)backSelected {
    [self.entryView discardEntry];
    [self.navView setNavTitleHidden:NO animated:YES];
    [self.navView setLeftButtonHidden:YES animated:YES];
}

-(void)setNavActive:(BOOL)active {
    [self.navView setButtonsAcive:active];
}

@end
