#import <UIKit/UIKit.h>
#import "BYCMood.h"

@protocol BYCMoodSpriteDelegate <NSObject>
-(void)startReached;
-(void)endReached;
@end

@interface BYCMoodSprite : UIView
-(id)initWithFrame:(CGRect)frame type:(BYCMoodType)type small:(BOOL)small;
-(void)setType:(BYCMoodType)type;
-(void)animate;
-(void)stopAnimation;
-(void)setDelegate:(id<BYCMoodSpriteDelegate>)delegate;
@end
