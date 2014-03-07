#import "BYCReminderViewController.h"
#import "BYCReminderView.h"

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
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    if(self.time.active) {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = self.time.date;
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.repeatInterval = NSCalendarUnitDay;
        notification.alertBody = @"How are you feeling?";
        notification.alertAction = @"New Entry";
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

@end