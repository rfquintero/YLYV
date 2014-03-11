#import "BYCTipsView.h"
#import "BYCUI.h"

@interface BYCTipsView()
@property (nonatomic) UILabel *title;
@property (nonatomic) UILabel *tip;
@property (nonatomic) UILabel *tap;
@end

@implementation BYCTipsView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = self.scrollView.backgroundColor;
        self.scrollView.backgroundColor = [UIColor clearColor];
        
        self.title = [BYCUI labelWithFontSize:20.0f];
        self.title.numberOfLines = 0;
        self.title.textAlignment = NSTextAlignmentCenter;
        
        self.tip = [BYCUI labelWithRoundFontSize:12.0f];
        self.tip.numberOfLines = 0;
        self.tip.textAlignment = NSTextAlignmentCenter;

        self.tap = [BYCUI labelWithFontSize:16.0f];
        self.tap.text = @"(tap or shake)";
        
        [self.scrollView addSubview:self.title];
        [self.scrollView addSubview:self.tip];
        [self.scrollView addSubview:self.tap];
        
        [self setTextHidden:YES animated:NO completion:^{}];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize maxSize = CGSizeMake(self.bounds.size.width-60, CGFLOAT_MAX);
    [self.tip centerInBounds:self.bounds offsetX:0 offsetY:-self.scrollView.contentInset.top-10 thatFits:maxSize];
    
    [self.title centerHorizonallyAtY:10.0f inBounds:self.bounds thatFits:maxSize];
    
    CGSize tapSize = [self.tap sizeThatFits:maxSize];
    [self.tap centerHorizonallyAtY:self.bounds.size.height-tapSize.height-15.0f-self.scrollView.contentInset.top inBounds:self.bounds withSize:tapSize];
    [self setContentHeight:CGRectGetMaxY(self.tap.frame)];
}

-(void)setTitle:(NSString*)title tip:(NSString*)tip {
    self.title.text = [title lowercaseString];
    self.tip.text = tip;
    
    if(tip.length < 40) {
        self.tip.font = [BYCUI roundFontOfSize:28.0f];
    } else if(tip.length < 100) {
        self.tip.font = [BYCUI roundFontOfSize:24.0f];
    } else {
        self.tip.font = [BYCUI roundFontOfSize:18.0f];
    }
}


-(void)setTitle:(NSString*)title tip:(NSString*)tip fadeOut:(BOOL)fadeOut {
    void(^completion)() = ^{
        [self setTitle:title tip:tip];
        [self layoutSubviews];
        [self setTextHidden:NO animated:YES completion:^{}];
    };
    
    if(fadeOut) {
        [self setTextHidden:YES animated:YES completion:completion];
    } else {
        completion();
    }
}

-(void)setTextHidden:(BOOL)hidden animated:(BOOL)animated completion:(void(^)())completion {
    if(animated) {
        self.scrollView.hidden = NO;
        [UIView animateWithDuration:0.2f animations:^{
            self.scrollView.alpha = hidden ? 0.0f : 1.0f;
        } completion:^(BOOL finished) {
            self.scrollView.hidden = hidden;
            completion();
        }];
    } else {
        self.scrollView.alpha = hidden ? 0.0f : 1.0f;
        self.scrollView.hidden = hidden;
    }
}

@end