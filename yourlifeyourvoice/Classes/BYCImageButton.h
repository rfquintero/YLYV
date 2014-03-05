#import <UIKit/UIKit.h>

@interface BYCImageButton : UIButton
@property (nonatomic, readonly) UIImageView *customImage;
@property (nonatomic, readonly) BOOL hasContent;
-(void)setImage:(UIImage*)image;
-(void)setImageTransform:(CGAffineTransform)transform;
@end
