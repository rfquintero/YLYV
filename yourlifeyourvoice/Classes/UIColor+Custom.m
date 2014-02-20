#import "UIColor+Custom.h"

#define CREATE_HEX_COLOR(colorName, colorHex) \
static UIColor * colorName = nil; \
+ (UIColor *)colorName { \
if (colorName) { \
return colorName; \
} else { \
colorName = [UIColor colorWithHexString:colorHex]; \
} \
return colorName; \
}

@implementation UIColor (Custom)

CREATE_HEX_COLOR(bgLightGray, @"#F4F4F4");

+ (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length {
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat:@"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString:fullHex] scanHexInt:&hexComponent];
    return hexComponent / 255.0;
}

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red = [self colorComponentFrom:colorString start:0 length:1];
            green = [self colorComponentFrom:colorString start:1 length:1];
            blue = [self colorComponentFrom:colorString start:2 length:1];
            break;
            
        case 4: // #ARGB
            alpha = [self colorComponentFrom:colorString start:0 length:1];
            red = [self colorComponentFrom:colorString start:1 length:1];
            green = [self colorComponentFrom:colorString start:2 length:1];
            blue = [self colorComponentFrom:colorString start:3 length:1];
            break;
            
        case 6: // #RRGGBB
            alpha = 1.0f;
            red = [self colorComponentFrom:colorString start:0 length:2];
            green = [self colorComponentFrom:colorString start:2 length:2];
            blue = [self colorComponentFrom:colorString start:4 length:2];
            break;
            
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom:colorString start:0 length:2];
            red = [self colorComponentFrom:colorString start:2 length:2];
            green = [self colorComponentFrom:colorString start:4 length:2];
            blue = [self colorComponentFrom:colorString start:6 length:2];
            break;
            
        default:
            [NSException raise:@"Invalid color value" format:@"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            break;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+(UIColor*)animatedColorFrom:(UIColor*)start to:(UIColor*)end percent:(CGFloat)percent {
    CGFloat startAlpha, startRed, startGreen, startBlue;
    CGFloat endAlpha, endRed, endGreen, endBlue;
    
    [self rgbaForColor:start red:&startRed green:&startGreen blue:&startBlue alpha:&startAlpha];
    [self rgbaForColor:end red:&endRed green:&endGreen blue:&endBlue alpha:&endAlpha];
    
    CGFloat red = [self animatedComponentFrom:startRed to:endRed percent:percent];
    CGFloat green = [self animatedComponentFrom:startGreen to:endGreen percent:percent];
    CGFloat blue = [self animatedComponentFrom:startBlue to:endBlue percent:percent];
    CGFloat alpha = [self animatedComponentFrom:startAlpha to:endAlpha percent:percent];
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+(CGFloat)animatedComponentFrom:(CGFloat)start to:(CGFloat)end percent:(CGFloat)percent {
    CGFloat range = end - start;
    return start + (range*percent);
}

+(void)rgbaForColor:(UIColor*)color red:(CGFloat*)red green:(CGFloat*)green blue:(CGFloat*)blue alpha:(CGFloat*)alpha {
    if(![color getRed:red green:green blue:blue alpha:alpha]) {
        CGFloat white;
        [color getWhite:&white alpha:alpha];
        *red = *blue = *green = white;
    }
}
@end
