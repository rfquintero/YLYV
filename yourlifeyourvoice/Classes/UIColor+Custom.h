#import <UIKit/UIKit.h>

@interface UIColor (Custom)

+(UIColor*)bgLightGray;
+(UIColor*)bgSidebarGray;
+(UIColor*)bgBlue;
+(UIColor*)bgYellow;
+(UIColor*)bgPurple;
+(UIColor*)bgGreen;
+(UIColor*)bgOrange;
+(UIColor*)bgRed;

+(UIColor*)textOrange;
+(UIColor*)textRed;
+(UIColor*)textDarkRed;

+(UIColor*)borderLightGray;

+(UIColor*)colorWithHexString:(NSString *)hexString;
+(UIColor*)animatedColorFrom:(UIColor*)start to:(UIColor*)end percent:(CGFloat)percent;
@end
