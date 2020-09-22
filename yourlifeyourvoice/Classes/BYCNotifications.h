#import <Foundation/Foundation.h>
#import "BYCReminderTime.h"

NS_ASSUME_NONNULL_BEGIN

@interface BYCNotifications : NSObject
+(void)setReminderTime:(BYCReminderTime*)time completion:(nullable void(^)(BOOL successful))completion;
+(void)removeReminders;
@end

NS_ASSUME_NONNULL_END
