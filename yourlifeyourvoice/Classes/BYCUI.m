#import "BYCUI.h"
#import <QuartzCore/QuartzCore.h>
#import "BYCNavigationView.h"

#define CREATE_FONT(fontName, labelName, font) \
+(UIFont *)fontName:(CGFloat)size { \
return [UIFont fontWithName:font size:size];\
}\
+(UILabel*)labelName:(CGFloat)size {\
return [self labelWithFont:[self fontName:size]];\
}

@implementation BYCUI
static NSNumberFormatter* _numberFormatter;
+(NSNumberFormatter*)numberFormatter {
    if(!_numberFormatter) {
        _numberFormatter = [[NSNumberFormatter alloc] init];
        _numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    }
    return _numberFormatter;
}

+(UILabel*)labelWithFont:(UIFont*)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.font = font;
    return label;
}

CREATE_FONT(fontOfSize, labelWithFontSize, @"WalterTurncoat");
CREATE_FONT(roundFontOfSize, labelWithRoundFontSize, @"ArialRoundedMTBold");

+(UIButton*)deleteButtonWithTarget:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor textRed] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor textDarkRed] forState:UIControlStateHighlighted];
    [button setTitle:@"X DELETE" forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setContentEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [button.titleLabel setFont:[self fontOfSize:16.0f]];
    return button;
}

+(UIButton*)standardButtonWithTitle:(NSString*)title target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setContentEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [button.titleLabel setFont:[self roundFontOfSize:18.0f]];
    button.layer.borderColor = [UIColor borderLightGray].CGColor;
    button.layer.borderWidth = 1.0f;
    return button;
}

+(NSString*)pluralize:(NSUInteger)number singular:(NSString*)singular {
    return [self pluralize:number singular:singular plural:[NSString stringWithFormat:@"%@s", singular]];
}

+(NSString*)pluralize:(NSUInteger)number singular:(NSString*)singular plural:(NSString*)plural {
    return [NSString stringWithFormat:@"%@ %@", [self formatNumber:@(number)], (number == 1 ? singular : plural)];
}

+(NSString*)formatNumber:(NSNumber*)number {
    return [[self numberFormatter] stringFromNumber:number];
}

+(CGFloat)topWindowInset {
    if (@available(iOS 11.0, *)) {
        if([UIApplication sharedApplication].keyWindow.safeAreaInsets.top > 20) {
            return 20;
        }
    }
    return 0;
}

+(CGFloat)bottomWindowInset {
    if (@available(iOS 11.0, *)) {
        if([UIApplication sharedApplication].keyWindow.safeAreaInsets.top > 20) {
            return [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;
        }
    }
    return 0;
}

+(void)setContentInsets:(UIScrollView*)scrollView {
    scrollView.contentInset = UIEdgeInsetsMake([BYCNavigationView navbarHeight], 0, [self bottomWindowInset], 0);
    
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
    }
}


@end
