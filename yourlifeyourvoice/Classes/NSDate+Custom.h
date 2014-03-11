#import <Foundation/Foundation.h>

@interface NSDate (Custom)
-(NSString*)timeAgo;
-(BOOL)isOnDays:(NSArray*)days startHour:(NSInteger)startHour startMinute:(NSInteger)startMinute endHour:(NSInteger)endHour endMinute:(NSInteger)endMinute;
@end
