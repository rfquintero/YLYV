#import <Foundation/Foundation.h>
#import "UIColor+Custom.h"
#import "UIView+Layouts.h"

@interface BYCUI : NSObject
+(UIFont*)fontOfSize:(CGFloat)size;
+(UIFont*)roundFontOfSize:(CGFloat)size;

+(UILabel*)labelWithFont:(UIFont*)font;
+(UILabel*)labelWithFontSize:(CGFloat)size;
+(UILabel*)labelWithRoundFontSize:(CGFloat)size;

+(UIButton*)deleteButtonWithTarget:(id)target action:(SEL)action;
+(UIButton*)standardButtonWithTitle:(NSString*)title target:(id)target action:(SEL)action;

+(NSString*)pluralize:(NSUInteger)number singular:(NSString*)singular;
+(NSString*)pluralize:(NSUInteger)number singular:(NSString*)singular plural:(NSString*)plural;
+(NSString*)formatNumber:(NSNumber*)number;
@end
