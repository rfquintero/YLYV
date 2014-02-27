#import "BYCMoodView.h"
#import "BYCUI.h"
#import "BYCMoodSprite.h"

#define kSpacing 5.0f

@interface BYCMoodView()
@property (nonatomic) BYCMoodSprite *face;
@property (nonatomic) BYCMoodType type;
@property (nonatomic) UILabel *text;
@property (nonatomic, weak) id<BYCMoodViewDelegate> delegate;
@end

@implementation BYCMoodView

-(id)initWithFrame:(CGRect)frame type:(BYCMoodType)type {
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        self.face = [[BYCMoodSprite alloc] initWithFrame:CGRectZero type:type];
        self.face.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moodSelected)];
        [self.face addGestureRecognizer:tapRecognizer];
        
        self.text = [BYCUI labelWithFontSize:14.0f];
        self.text.text = [BYCMood moodString:type];
        
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
    
    [self.face centerHorizonallyAtY:0 inBounds:self.bounds withSize:CGSizeMake(_faceSize, _faceSize)];
}

-(CGSize)sizeThatFits:(CGSize)size {
    CGSize textSize = [self.text sizeThatFits:CGSizeUnbounded];

    return CGSizeMake(MAX(_faceSize, textSize.width), _faceSize + textSize.height + kSpacing);
}

-(void)setType:(BYCMoodType)type {
    _type = type;
    [self.face setType:type];
    self.text.text = [BYCMood moodString:type];
}

-(void)moodSelected {
    [self.delegate moodView:self selectedWithType:self.type];
    [self animate];
}

-(void)animate {
    [self.face animate];
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
