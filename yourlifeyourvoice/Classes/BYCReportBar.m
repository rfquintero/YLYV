#import "BYCReportBar.h"
#import "BYCMoodView.h"
#import "BYCUI.h"
#import "BYCConstants.h"

#define kFaceSize 50.0f

@interface BYCReportBar()
@property (nonatomic) BYCMoodView *moodView;
@property (nonatomic) UILabel *mood;
@property (nonatomic) UILabel *percent;
@property (nonatomic) UIView *bar;
@property (nonatomic) CGFloat widthPercentage;
@end

@implementation BYCReportBar

-(id)initWithReuseIdentifier:(NSString*)identifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        self.moodView = [[BYCMoodView alloc] initWithFrame:CGRectZero type:BYCMood_Angry small:YES];
        self.moodView.faceSize = kFaceSize;
        [self.moodView setTextHidden:YES animated:NO];
        
        self.mood = [BYCUI labelWithFontSize:16.0f];
        self.percent = [BYCUI labelWithRoundFontSize:12.0f];
        
        self.bar = [[UIView alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:self.bar];
        [self.contentView addSubview:self.moodView];
        [self.contentView addSubview:self.mood];
        [self.contentView addSubview:self.percent];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = self.contentView.bounds.size.width;
    CGFloat padding = 10.0f;
    
    [self.moodView centerVerticallyAtX:padding inBounds:self.contentView.bounds withSize:CGSizeMake(kFaceSize, kFaceSize)];
    
    CGSize moodSize = [self.mood sizeThatFits:CGSizeUnbounded];
    CGFloat offsetX = CGRectGetMaxX(self.moodView.frame)+padding;
    self.mood.frame = CGRectMake(offsetX, self.moodView.center.y-moodSize.height, moodSize.width, moodSize.height);
    [self.percent setFrameAtOriginThatFitsUnbounded:CGPointMake(offsetX, self.moodView.center.y)];
    
    CGFloat barWidth = kFaceSize/2 + (width-offsetX)*self.widthPercentage;
    self.bar.frame = CGRectMake(self.moodView.center.x, self.moodView.frame.origin.y, barWidth, kFaceSize);
}

-(CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(size.width, 70);
}

-(void)setMoodType:(BYCMoodType)type count:(NSUInteger)count percent:(CGFloat)percent {
    [self.moodView setType:type];
    self.bar.backgroundColor = [BYCMood moodColor:type];
    self.mood.text = [BYCMood moodString:type];
    self.percent.text = [NSString stringWithFormat:@"(%@) %i%%", [BYCUI formatNumber:@(count)], (int)roundf(percent*100)];
    self.widthPercentage = percent;
    [self setNeedsLayout];
}

-(void)animateWithDelay:(CGFloat)delay {
    [self layoutSubviews];
    self.bar.frame = CGRectMake(self.bar.frame.origin.x, self.bar.frame.origin.y, 0, self.bar.frame.size.height);
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [UIView animateWithDuration:0.3f delay:delay usingSpringWithDamping:0.5f initialSpringVelocity:0 options:0 animations:^{
            [self layoutSubviews];
        } completion:^(BOOL finished) {
        }];
    } else {
        [UIView animateWithDuration:0.2f delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self layoutSubviews];
        } completion:^(BOOL finished) {
        }];
    }
}

@end
