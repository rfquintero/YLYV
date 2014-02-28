#import "BYCAddReasonsViewController.h"
#import "BYCAddReasonsView.h"

@interface BYCAddReasonsViewController()<BYCAddReasonsViewDelegate>
@property (nonatomic) BYCEntryModel *model;
@property (nonatomic) BYCAddReasonsView *entryView;
@end

@implementation BYCAddReasonsViewController

-(id)initWithApplicationState:(BYCApplicationState *)applicationState model:(BYCEntryModel*)model {
    if(self = [super initWithApplicationState:applicationState]) {
        self.model = model;
    }
    return self;
}

-(void)loadView {
    [super loadView];
    
    self.entryView = [[BYCAddReasonsView alloc] initWithFrame:CGRectZero];
    self.entryView.delegate = self;
    self.entryView.reasons = self.model.reasons;
    
    [self.navView setContentView:self.entryView];
    [self.navView setNavTitle:@"because of..."];
    [self setupBackButton];
}

-(void)reasonAdded:(NSString*)reason {
    [self.model addReason:reason];
}

-(void)reasonRemoved:(NSString*)reason {
    [self.model removeReason:reason];
}
@end