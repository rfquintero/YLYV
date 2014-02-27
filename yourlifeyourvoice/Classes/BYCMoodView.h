#import <UIKit/UIKit.h>
#import "BYCMood.h"

@class BYCMoodView;

@protocol BYCMoodViewDelegate <NSObject>
-(void)moodView:(BYCMoodView*)view selectedWithType:(BYCMoodType)type;
@end

@interface BYCMoodView : UIView
@property (nonatomic) CGFloat faceSize;
-(id)initWithFrame:(CGRect)frame type:(BYCMoodType)type;
-(void)setTextHidden:(BOOL)hidden animated:(BOOL)animated;
-(void)setTextFont:(UIFont*)font;
-(void)setType:(BYCMoodType)type;
-(void)animate:(BOOL)animate;
-(void)setDelegate:(id<BYCMoodViewDelegate>)delegate;
@end
