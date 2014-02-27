#import <UIKit/UIKit.h>
#import "BYCMood.h"

@interface BYCMoodSprite : UIView
-(id)initWithFrame:(CGRect)frame type:(BYCMoodType)type;
-(void)setType:(BYCMoodType)type;
-(void)animate;
@end
