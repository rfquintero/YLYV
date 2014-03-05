#import "BYCUI.h"
#import <QuartzCore/QuartzCore.h>

#define CREATE_FONT(fontName, labelName, font) \
+(UIFont *)fontName:(CGFloat)size { \
return [UIFont fontWithName:font size:size];\
}\
+(UILabel*)labelName:(CGFloat)size {\
return [self labelWithFont:[self fontName:size]];\
}

@implementation BYCUI
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

@end
