#import "BYCReminderViewController.h"
#import "BYCReminderView.h"
#import "BYCNotifications.h"

@interface BYCReminderViewController ()<BYCReminderViewDelegate>
@property (nonatomic) BYCReminderView *entryView;
@property (nonatomic) BYCReminderTime *time;
@end

@implementation BYCReminderViewController

-(void)loadView {
    [super loadView];
    
    self.time = [self.applicationState.database getReminderTime];
    if(!self.time) {
        self.time = [[BYCReminderTime alloc] init];
        self.time.active = NO;
        [self.time setTimeWithHour:17 minute:0];
    }
    
    self.entryView = [[BYCReminderView alloc] initWithFrame:CGRectZero];
    self.entryView.delegate = self;
    [self.entryView setTime:self.time];
    
    [self.navView setContentView:self.entryView];
    [self.navView setNavTitle:@"Reminder"];
    [self setupMenuButton];
    self.screenName = @"Reminder";
}

-(void)refresh {
    [self.applicationState.database saveReminderTime:self.time];
    [self.entryView setTime:self.time];
    [self setupNotification];
}

-(void)timeSelected:(NSDate *)time {
    [self.time setTimeWithDate:time];
    [self refresh];
}

-(void)activeChanged:(BOOL)active {
    self.time.active = active;
    [self refresh];
}

-(void)setupNotification {
    [BYCNotifications setReminderTime:self.time completion:^(BOOL successful) {
        if(!successful) {
            [self removeNotification];
        }
    }];
}

-(void)removeNotification {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Unable to setup a reminder. Please check in Settings that Notifications are allowed for this application." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [self.entryView setActive:NO];
    [alert show];
}

@end
