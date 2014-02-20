#import "BYCMoodView.h"
#import "BYCUI.h"

#define kSpacing 5.0f

@interface BYCMoodView()
@property (nonatomic) UIImageView *face;
@property (nonatomic) BYCMoodViewType type;
@property (nonatomic) UILabel *text;
@end

@implementation BYCMoodView

-(id)initWithFrame:(CGRect)frame type:(BYCMoodViewType)type {
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        self.face = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"face_lonely"]];
        
        self.text = [BYCUI labelWithFontSize:14.0f];
        self.text.text = [self moodString];
        
        [self addSubview:self.face];
        [self addSubview:self.text];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    if(self.text.hidden) {
        self.face.frame = self.bounds;
    } else {
        CGFloat height = self.bounds.size.height;
        CGSize textSize = [self.text sizeThatFits:CGSizeUnbounded];
        [self.text centerHorizonallyAtY:height-textSize.height inBounds:self.bounds withSize:textSize];
        
        CGFloat faceSize = height-textSize.height-kSpacing;
        [self.face centerHorizonallyAtY:0 inBounds:self.bounds withSize:CGSizeMake(faceSize, faceSize)];
    }
}

-(CGSize)sizeThatFits:(CGSize)size {
    CGSize faceSize = [self.face sizeThatFits:CGSizeUnbounded];
    CGSize textSize = [self.text sizeThatFits:CGSizeUnbounded];
    if(self.text.hidden) {
        return faceSize;
    } else {
        return CGSizeMake(MAX(faceSize.width, textSize.width), faceSize.height + textSize.height + kSpacing);
    }
}

-(void)setTextHidden:(BOOL)hidden animated:(BOOL)animated {
    if(animated) {
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
