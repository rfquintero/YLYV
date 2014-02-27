#import <UIKit/UIKit.h>

@interface BYCImageButton : UIButton
@property (nonatomic, readonly) UIImageView *customImage;
-(void)setImage:(UIImage*)image;
-(void)setImageTransform:(CGAffineTransform)transform;
@end
