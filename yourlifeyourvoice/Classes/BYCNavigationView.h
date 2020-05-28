#import <UIKit/UIKit.h>
#import "BYCContentView.h"

@interface BYCNavigationView : UIView
-(void)setNavTitle:(NSString*)title;
-(void)setNavImage:(UIImage*)image;
-(void)setNavTitleHidden:(BOOL)hidden animated:(BOOL)animated;
-(void)setContentView:(UIView *)contentView;

-(void)setupBackButton:(id)target action:(SEL)action;
-(void)setupMenuButton:(id)target action:(SEL)action;
-(void)setupLeftButton:(UIImage*)image target:(id)target action:(SEL)action;
-(void)setupLeftButton2:(UIImage*)image target:(id)target action:(SEL)action;
-(void)setupRightButton:(UIImage*)image target:(id)target action:(SEL)action;
-(void)setLeftButtonHidden:(BOOL)hidden animated:(BOOL)animated;
-(void)setRightButtonHidden:(BOOL)hidden animated:(BOOL)animated;
-(void)setLeftButton2Hidden:(BOOL)hidden animated:(BOOL)animated;
-(void)setButtonsAcive:(BOOL)active;

+(CGFloat)navbarInset;
+(CGFloat)navbarHeight;
@end
