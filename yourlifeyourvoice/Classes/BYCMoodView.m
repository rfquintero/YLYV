#import "BYCMoodView.h"
#import "BYCUI.h"

#define kSpacing 5.0f

@interface BYCMoodView()
@property (nonatomic) UIImageView *face;
@property (nonatomic) BYCMoodViewType type;
@property (nonatomic) UILabel *text;
@property (nonatomic, weak) id<BYCMoodViewDelegate> delegate;
@end

@implementation BYCMoodView

-(id)initWithFrame:(CGRect)frame type:(BYCMoodViewType)type {
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        self.face = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"face_lonely"]];
        self.face.contentMode = UIViewContentModeScaleAspectFill;
        self.face.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moodSelected)];
        [self.face addGestureRecognizer:tapRecognizer];
        
        self.text = [BYCUI labelWithFontSize:14.0f];
        self.text.text = [self moodString];
        
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

-(void)moodSelected {
    [self.delegate moodView:self selectedWithType:self.type];
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

-(NSString*)moodString {
    switch(self.type) {
        case BYCMoodView_Lonely:
            return @"Lonely";
    }
}

@end
