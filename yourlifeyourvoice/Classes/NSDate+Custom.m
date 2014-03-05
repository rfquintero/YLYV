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
    NSTimeInterval time = -[self timeIntervalSinceNow];
    if(time < 60) {
        return @"just now";
    } else if(time < 60*60){
        return [self ago:[BYCUI pluralize:(int)(time/60.0f) singular:@"minute"] withDay:NO];
    } else if(time < 60*60*24) {
        return [self ago:[BYCUI pluralize:(int)(time/(60*60)) singular:@"hour"] withDay:NO];
    } else if(time < 60*60*24*7) {
        return [self ago:[BYCUI pluralize:(int)(time/(60*60*24)) singular:@"day"] withDay:YES];
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

@end
