#import "BYCReminderTime.h"

@interface BYCReminderTime()
@property (nonatomic, readwrite) NSDateComponents *components;
@property (nonatomic, readwrite) NSDate *date;
@end

@implementation BYCReminderTime

static NSDateFormatter* _timeFormatter;

+(NSDateFormatter*)timeFormatter {
    if(!_timeFormatter) {
        _timeFormatter = [[NSDateFormatter alloc] init];
        _timeFormatter.dateFormat = @"h:mm a";
    }
    return _timeFormatter;
}

-(void)setComponents:(NSDateComponents *)components {
    _components = components;
    _date = [[NSCalendar currentCalendar] dateFromComponents:components];
}

-(void)setTimeWithDate:(NSDate*)date {
    self.components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:date];
}

-(void)setTimeWithHour:(NSInteger)hour minute:(NSInteger)minute {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.hour = hour;
    components.minute = minute;
    self.components = components;
}

-(NSInteger)hour {
    return self.components.hour;
}

-(NSInteger)minute {
    return self.components.minute;
}

-(NSString*)string {
    return [[BYCReminderTime timeFormatter] stringFromDate:self.date];
}

@end
