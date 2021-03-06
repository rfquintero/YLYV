#import "BYCNavigationView.h"
#import "BYCUI.h"
#import "BYCConstants.h"

#define kBarHeight 44

@interface BYCNavigationView()
@property (nonatomic) UIView *contentView;
@property (nonatomic) UILabel *title;
@property (nonatomic) UIImageView *titleImage;
@property (nonatomic) UIButton *leftButton;
@property (nonatomic) UIButton *leftButton2;
@property (nonatomic) UIButton *rightButton;
@property (nonatomic) UIView *barView;
@end

@implementation BYCNavigationView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.title = [BYCUI labelWithRoundFontSize:18.0f];
        self.title.textColor = [UIColor blackColor];
        
        self.barView = [[UIView alloc] initWithFrame:CGRectZero];
        self.barView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8f];
        
        self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.leftButton setContentEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 12)];
        
        self.leftButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.leftButton2 setContentEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 12)];
        [self setView:self.leftButton2 hidden:YES animated:NO];
        
        self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.rightButton setContentEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 12)];
        
        [self.barView addSubview:self.title];
        [self.barView addSubview:self.leftButton];
        [self.barView addSubview:self.rightButton];
        [self.barView addSubview:self.leftButton2];
        
        [self addSubview:self.barView];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = self.bounds.size.width;
    CGFloat extra = [BYCNavigationView navbarInset];
    
    self.barView.frame = CGRectMake(0, 0, width, kBarHeight+extra);
    [self.leftButton centerVerticallyAtX:0 inBounds:self.barView.bounds thatFits:CGSizeUnbounded offsetY:extra/2];
    self.leftButton2.frame = self.leftButton.frame;
    CGSize rightSize = [self.rightButton sizeThatFits:CGSizeUnbounded];
    [self.rightButton centerVerticallyAtX:width-rightSize.width inBounds:self.barView.bounds withSize:rightSize offsetY:extra/2];
    
    CGFloat titleWidth = CGRectGetMinX(self.rightButton.frame) - CGRectGetMaxX(self.leftButton.frame)-20.0f;
    [self.title centerInBounds:self.barView.bounds offsetX:0 offsetY:extra/2 thatFits:CGSizeMake(titleWidth, kBarHeight)];
    [self.titleImage centerInBounds:self.barView.bounds offsetX:0 offsetY:extra/2 thatFits:CGSizeMake(titleWidth, kBarHeight)];
    
    self.contentView.frame = self.bounds;
}

-(void)setNavTitle:(NSString*)title {
    self.title.hidden = NO;
    self.titleImage.hidden = YES;
    self.title.text = title;
    [self setNeedsLayout];
}

-(void)setNavImage:(UIImage *)image {
    if(!self.titleImage) {
        self.titleImage = [[UIImageView alloc] initWithImage:image];
        [self addSubview:self.titleImage];
    } else {
        self.titleImage.image = image;
    }
    self.titleImage.hidden = NO;
    self.title.hidden = YES;
    [self setNeedsLayout];
}

-(void)setContentView:(UIView *)contentView {
    [_contentView removeFromSuperview];
    _contentView = contentView;
    [self addSubview:contentView];
    [self bringSubviewToFront:self.barView];
    [self setNeedsLayout];
}

-(void)setupButton:(UIButton*)button image:(UIImage*)image target:(id)target action:(SEL)action {
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self setNeedsLayout];
}

-(void)setupBackButton:(id)target action:(SEL)action {
    [self setupLeftButton:[UIImage imageNamed:@"icon_navbar_back"] target:target action:action];
}

-(void)setupMenuButton:(id)target action:(SEL)action {
    [self setupRightButton:[UIImage imageNamed:@"icon_navbar_menu"] target:target action:action];
}

-(void)setupLeftButton:(UIImage *)image target:(id)target action:(SEL)action {
    [self setupButton:self.leftButton image:image target:target action:action];
}

-(void)setupRightButton:(UIImage*)image target:(id)target action:(SEL)action {
    [self setupButton:self.rightButton image:image target:target action:action];
}

-(void)setupLeftButton2:(UIImage*)image target:(id)target action:(SEL)action {
    [self setupButton:self.leftButton2 image:image target:target action:action];
}

-(void)setView:(UIView*)view hidden:(BOOL)hidden animated:(BOOL)animated {
    if(animated) {
        view.hidden = NO;
        [UIView animateWithDuration:0.3f animations:^{
            view.alpha = hidden ? 0.0f : 1.0f;
        } completion:^(BOOL finished) {
            view.hidden = hidden;
        }];
    } else {
        view.alpha = hidden ? 0.0f : 1.0f;
        view.hidden = hidden;
    }
}

-(void)setLeftButtonHidden:(BOOL)hidden animated:(BOOL)animated {
    [self setView:self.leftButton hidden:hidden animated:animated];
}

-(void)setRightButtonHidden:(BOOL)hidden animated:(BOOL)animated {
    [self setView:self.rightButton hidden:hidden animated:animated];
}

-(void)setLeftButton2Hidden:(BOOL)hidden animated:(BOOL)animated {
    [self setView:self.leftButton2 hidden:hidden animated:animated];
}

-(void)setNavTitleHidden:(BOOL)hidden animated:(BOOL)animated {
    [self setView:self.title hidden:hidden animated:animated];
}

-(void)setButtonsAcive:(BOOL)active {
    self.leftButton.userInteractionEnabled = active;
    self.rightButton.userInteractionEnabled = active;
    self.barView.userInteractionEnabled = active;
}

+(CGFloat)navbarInset {
    return [BYCUI topWindowInset] + (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ? 20.0f : 0.0f);
}

+(CGFloat)navbarHeight {
    return kBarHeight + [self navbarInset];
}

@end
