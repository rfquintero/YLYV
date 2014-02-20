#import <UIKit/UIKit.h>

@interface BYCContentView : UIView
@property (nonatomic, readonly) UIScrollView *scrollView;
-(void)setContentHeight:(CGFloat)height;
@end