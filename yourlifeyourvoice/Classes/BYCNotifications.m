#import "BYCNotifications.h"
#import "BYCConstants.h"
#import <UserNotifications/UserNotifications.h>

#define BYCNotificationsReminder @"BYCNotificationsReminder"

@implementation BYCNotifications

+(void)setReminderTime:(BYCReminderTime*)time completion:(nullable void(^)(BOOL successful))completion {
    [self removeReminders];
    if(time.active) {
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")) {
            [self setupNotification:time completion:completion];
        } else {
            [self setupNotificationLegacy:time];
        }
    }
}

+(void)removeReminders {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")) {
        [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:@[BYCNotificationsReminder]];
        [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:@[BYCNotificationsReminder]];
    }
}

+(void)setupNotification:(BYCReminderTime*)time completion:(nullable void(^)(BOOL successful))completion {
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionAlert|UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if(error) {
            completion(NO);
        } else if(!granted) {
            completion(NO);
        } else {
            UNMutableNotificationContent *notification = [[UNMutableNotificationContent alloc] init];
            notification.title = @"New Entry";
            notification.body = @"How are you feeling?";
            
            UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:time.components repeats:YES];
            
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:BYCNotificationsReminder content:notification trigger:trigger];
            
            [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                if(error && completion) {
                    completion(NO);
                }
            }];
        }
    }];
}

+(void)setupNotificationLegacy:(BYCReminderTime*)time {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = time.date;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.repeatInterval = NSCalendarUnitDay;
    notification.alertBody = @"How are you feeling?";
    notification.alertAction = @"New Entry";
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

@end
