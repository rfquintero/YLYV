#import "BYCTipsViewController.h"
#import "BYCTipsView.h"

@interface BYCTipsViewController ()
@property (nonatomic) BYCTipsView *entryView;
@property (nonatomic) NSMutableDictionary *currentTips;
@property (nonatomic) NSMutableDictionary *otherTips;
@end

@implementation BYCTipsViewController

-(void)loadView {
    [super loadView];
    
    self.entryView = [[BYCTipsView alloc] initWithFrame:self.view.bounds];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextTip)];
    [self.entryView addGestureRecognizer:tap];
    
    [self setupTips];
    
    [self.navView setContentView:self.entryView];
    [self.navView setNavTitle:@"Life Tips"];
    self.screenName = @"Life Tips";
    [self setupMenuButton];
    [self nextTip:NO];
}

-(void)nextTip {
    [self trackEvent:@"life_tips" action:@"next tip" label:nil];
    [self nextTip:YES];
}

-(void)nextTip:(BOOL)fadeOut {
    if(self.currentTips.count == 0 && self.otherTips.count == 0) {
        [self setupTips];
    }
    if(self.currentTips.count == 0) {
        self.currentTips = self.otherTips;
        self.otherTips = [NSMutableDictionary dictionary];
    }

    NSString *key = [self random:self.currentTips.allKeys];
    NSMutableArray *tips = self.currentTips[key];
    NSString *tip = [self random:tips];
    [tips removeObject:tip];
    if(tips.count == 0) {
        [self.currentTips removeObjectForKey:key];
    }
    [self.entryView setTitle:key tip:tip fadeOut:fadeOut];
}

-(void)setupTips {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"tips" ofType:@"plist"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSMutableDictionary *tips = (NSMutableDictionary*)[NSPropertyListSerialization propertyListFromData:data mutabilityOption:NSPropertyListMutableContainers format:nil errorDescription:nil];
    self.currentTips = [NSMutableDictionary dictionary];
    self.otherTips = [NSMutableDictionary dictionary];
    
    NSString *moodKey = self.mood ? [BYCMood moodString:[self.mood intValue]] : nil;

    for(NSString *key in tips.allKeys) {
        if(moodKey && [key isEqual:moodKey]) {
            [self.currentTips addEntriesFromDictionary:tips[key]];
        } else {
            [self.otherTips addEntriesFromDictionary:tips[key]];
        }
    }
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
