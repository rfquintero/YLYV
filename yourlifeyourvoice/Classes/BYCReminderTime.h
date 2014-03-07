#import <Foundation/Foundation.h>

@interface BYCReminderTime : NSObject
@property (nonatomic, readonly) NSInteger hour;
@property (nonatomic, readonly) NSInteger minute;
@property (nonatomic, readonly) NSString *string;
@property (nonatomic, readonly) NSDate *date;
@property (nonatomic) BOOL active;

-(void)setTimeWithDate:(NSDate*)date;
-(void)setTimeWithHour:(NSInteger)hour minute:(NSInteger)minute;
@end
