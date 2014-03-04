#import <UIKit/UIKit.h>
#import "BYCMood.h"

@interface BYCMoodSprite : UIView
-(id)initWithFrame:(CGRect)frame type:(BYCMoodType)type small:(BOOL)small;
-(void)setType:(BYCMoodType)type;
-(void)animate;
-(void)resetAnimation;
-(void)animateAll;
@end
