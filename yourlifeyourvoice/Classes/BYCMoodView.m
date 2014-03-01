#import "BYCMoodView.h"
#import "BYCUI.h"
#import "BYCMoodSprite.h"

#define kSpacing 5.0f

@interface BYCMoodView()
@property (nonatomic) BYCMoodSprite *sprite;
@property (nonatomic) UIImageView *face;
@property (nonatomic) BYCMoodType type;
@property (nonatomic) UILabel *text;
@property (nonatomic, weak) id<BYCMoodViewDelegate> delegate;
@end

@implementation BYCMoodView

-(id)initWithFrame:(CGRect)frame type:(BYCMoodType)type {
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        self.sprite = [[BYCMoodSprite alloc] initWithFrame:CGRectZero type:type];
        self.face = [[UIImageView alloc] initWithImage:[BYCMood moodImage:type]];
        self.face.hidden = YES;
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moodSelected)];
        [self addGestureRecognizer:tapRecognizer];
        
        self.text = [BYCUI labelWithFontSize:14.0f];
        self.text.text = [BYCMood moodString:type];
        
        [self addSubview:self.sprite];
        [self addSubview:self.face];
        [self addSubview:self.text];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat height = self.bounds.size.height;
    CGSize textSize = [self.text sizeThatFits:CGSizeUnbounded];
    [self.text centerHorizonallyAtY:height-textSize.height inBounds:self.bounds withSize:textSize];
    
    [self.sprite centerHorizonallyAtY:0 inBounds:self.bounds withSize:CGSizeMake(_faceSize, _faceSize)];
    [self.face centerHorizonallyAtY:0 inBounds:self.bounds withSize:CGSizeMake(_faceSize, _faceSize)];
}

-(CGSize)sizeThatFits:(CGSize)size {
    CGSize textSize = [self.text sizeThatFits:CGSizeUnbounded];
    CGFloat height = _faceSize + textSize.height + kSpacing;
    
    return CGSizeMake(_faceSize, height);
}

-(void)setType:(BYCMoodType)type {
    _type = type;
    [self.sprite setType:type];
    self.face.image = [BYCMood moodImage:type];
    self.text.text = [BYCMood moodString:type];
}

-(void)moodSelected {
    [self.delegate moodView:self selectedWithType:self.type];
    [self animate:YES];
}

-(void)animate:(BOOL)animate {
    if(animate) {
        [self.sprite animate];
    }
    self.sprite.hidden = !animate;
    self.face.hidden = animate;
}

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

@end
