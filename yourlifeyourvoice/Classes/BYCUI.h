#import <Foundation/Foundation.h>
#import "UIColor+Custom.h"
#import "UIView+Layouts.h"

@interface BYCUI : NSObject
+(UIFont*)fontOfSize:(CGFloat)size;
+(UIFont*)boldFontOfSize:(CGFloat)size;

+(UILabel*)labelWithFont:(UIFont*)font;
+(UILabel*)labelWithFontSize:(CGFloat)size;
+(UILabel*)labelWithBoldFontSize:(CGFloat)size;
@end
