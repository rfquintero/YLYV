#import <UIKit/UIKit.h>

@interface UIColor (Custom)

+(UIColor*)bgLightGray;
+(UIColor*)bgSidebarGray;
+(UIColor*)textOrange;

+(UIColor*)colorWithHexString:(NSString *)hexString;
+(UIColor*)animatedColorFrom:(UIColor*)start to:(UIColor*)end percent:(CGFloat)percent;
@end
