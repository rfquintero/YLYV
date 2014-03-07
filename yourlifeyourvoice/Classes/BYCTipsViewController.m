#import "BYCTipsViewController.h"
#import "BYCTipsView.h"

@interface BYCTipsViewController ()
@property (nonatomic) BYCTipsView *entryView;
@property (nonatomic) NSDictionary *tips;
@end

@implementation BYCTipsViewController

-(void)loadView {
    [super loadView];
    
    self.entryView = [[BYCTipsView alloc] initWithFrame:self.view.bounds];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextTip)];
    [self.entryView addGestureRecognizer:tap];
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"tips" ofType:@"plist"];
    self.tips = [NSDictionary dictionaryWithContentsOfFile:path];
    
    [self.navView setContentView:self.entryView];
    [self.navView setNavTitle:@"Life Tips"];
    [self setupMenuButton];
    [self nextTip:NO];
}

-(void)nextTip {
    [self nextTip:YES];
}

-(void)nextTip:(BOOL)fadeOut {
    NSString *key = [self random:self.tips.allKeys];
    NSString *tip = [self random:self.tips[key]];
    [self.entryView setTitle:key tip:tip fadeOut:fadeOut];
}

-(NSString*)random:(NSArray*)array {
    return array[random()%array.count];
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if(motion == UIEventSubtypeMotionShake) {
        [self nextTip];
    }
}

@end
