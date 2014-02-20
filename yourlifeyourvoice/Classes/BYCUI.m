#import "BYCUI.h"

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
    label.font = font;
    return label;
}

CREATE_FONT(fontOfSize, labelWithFontSize, @"Helvetica");
CREATE_FONT(boldFontOfSize, labelWithBoldFontSize, @"Helvetica-Bold");
@end
