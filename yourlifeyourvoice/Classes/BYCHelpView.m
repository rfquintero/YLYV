#import "BYCHelpView.h"
#import "BYCUI.h"

#define kSpacing 5.0f

@interface BYCHelpView()
@property (nonatomic) UIButton *button;
@property (nonatomic) UILabel *text;
@end

@implementation BYCHelpView

-(id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.backgroundColor = [UIColor blackColor];
        self.button.clipsToBounds = YES;
        [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.button setTitle:@"HELP" forState:UIControlStateNormal];
        [self.button.titleLabel setFont:[BYCUI roundFontOfSize:18.0f]];
        [self.button addTarget:self action:@selector(helpSelected) forControlEvents:UIControlEventTouchUpInside];
        
        self.text = [BYCUI labelWithFontSize:16.0f];
        self.text.text = @"4 Ways to Get Help";
        
        [self addSubview:self.button];
        [self addSubview:self.text];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat height = self.bounds.size.height;
    CGSize textSize = [self.text sizeThatFits:CGSizeUnbounded];
    [self.text centerHorizonallyAtY:height-textSize.height inBounds:self.bounds withSize:textSize];
    
    [self.button centerHorizonallyAtY:0 inBounds:self.bounds withSize:CGSizeMake(_faceSize, _faceSize)];
}

-(CGSize)sizeThatFits:(CGSize)size {
    CGSize textSize = [self.text sizeThatFits:CGSizeUnbounded];
    CGFloat height = _faceSize + textSize.height + kSpacing;
    
    return CGSizeMake(_faceSize, height);
}

-(void)setFaceSize:(CGFloat)faceSize {
    _faceSize = faceSize;
    self.button.layer.cornerRadius = faceSize/2.0f;
    
    [self setNeedsLayout];
}

-(void)helpSelected {
    [self.delegate helpSelected];
}

#pragma mark MoodView imitators
-(void)setTextHidden:(BOOL)hidden animated:(BOOL)animated {
    if(animated) {
        self.text.hidden = NO;
        [UIView animateWithDuration:0.3f animations:^{
            self.text.alpha = hidden ? 0.0f : 1.0f;
        } completion:^(BOOL finished) {
            self.text.hidden = hidden;
        }];
    } else {
        self.text.alpha = hidden ? 0.0f : 1.0f;
        self.text.hidden = hidden;
    }
}

-(void)setTextFont:(UIFont*)font {
    self.text.font = font;
    [self setNeedsLayout];
}

-(void)animateStep {
    
}

-(void)stopAnimation {
    
}

@end
