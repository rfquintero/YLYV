#import <UIKit/UIKit.h>

@protocol BYCHelpViewDelegate <NSObject>
-(void)helpSelected;
@end

@interface BYCHelpView : UIView
@property (nonatomic) CGFloat faceSize;
@property (nonatomic, weak) id<BYCHelpViewDelegate> delegate;

-(void)setTextHidden:(BOOL)hidden animated:(BOOL)animated;
-(void)setTextFont:(UIFont*)font;
-(void)animateStep;
-(void)stopAnimation;
@end