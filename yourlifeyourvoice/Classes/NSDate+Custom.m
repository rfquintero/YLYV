#import "NSDate+Custom.h"
#import "BYCUI.h"

@implementation NSDate (Custom)

static NSDateFormatter* _dateFormatter;
static NSDateFormatter* _dayFormatter;

+(NSDateFormatter*)dateFormatter {
    if(!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"M/d/yyyy";
    }
    return _dateFormatter;
}

+(NSDateFormatter*)dayFormatter {
    if(!_dayFormatter) {
        _dayFormatter = [[NSDateFormatter alloc] init];
        _dayFormatter.dateFormat = @"EEEE";
    }
    return _dayFormatter;
}

-(NSString*)timeAgo {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:self toDate:[NSDate date] options:0];
    NSTimeInterval time = -[self timeIntervalSinceNow];
    if(time < 60) {
        return @"just now";
    } else if(time < 60*60){
        return [self ago:[BYCUI pluralize:(int)(time/60.0f) singular:@"minute"] withDay:NO];
    } else if(time < 60*60*24) {
        return [self ago:[BYCUI pluralize:(int)(time/(60*60)) singular:@"hour"] withDay:NO];
    } else if(time < 60*60*24*7) {
        return [self ago:[BYCUI pluralize:components.day singular:@"day"] withDay:YES];
    } else {
        return [[NSDate dateFormatter] stringFromDate:self];
    }
}

-(NSString*)ago:(NSString*)time withDay:(BOOL)withDay {
    if(withDay) {
        return [NSString stringWithFormat:@"%@ ago, %@", time, [[NSDate dayFormatter] stringFromDate:self]];
    }
    return [NSString stringWithFormat:@"%@ ago", time];
}

-(BOOL)isOnDays:(NSArray*)days startHour:(NSInteger)startHour startMinute:(NSInteger)startMinute endHour:(NSInteger)endHour endMinute:(NSInteger)endMinute {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"CDT"];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:self];
    for(NSNumber *day in days) {
        if(components.weekday == [day integerValue]) {
            if(components.hour == startHour) {
                return components.minute >= startMinute;
            } else if(components.hour == endHour) {
                return components.minute <= endMinute;
            } else if(components.hour > startHour && components.hour < endHour) {
                return YES;
            }
        }
    }
    
    return NO;
}

@end
