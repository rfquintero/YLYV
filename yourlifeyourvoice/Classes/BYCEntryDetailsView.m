#import "BYCEntryDetailsView.h"
#import "BYCAddEntryView.h"
#import "BYCMoodView.h"
#import "BYCConstants.h"
#import "BYCUI.h"

#define kLargeSize 190.0f

@interface BYCEntryDetailsView()<BYCMoodViewDelegate>
@property (nonatomic) BYCMoodView *largeMood;
@property (nonatomic, readwrite) BYCAddEntryView *addEntry;
@end

@implementation BYCEntryDetailsView

-(id)initWithFrame:(CGRect)frame type:(BYCMoodType)type {
    self = [super initWithFrame:frame];
    if (self) {
        self.largeMood = [[BYCMoodView alloc] initWithFrame:CGRectZero type:type small:NO];
        self.largeMood.userInteractionEnabled = YES;
        self.largeMood.faceSize = kLargeSize;
        self.largeMood.delegate = self;
        [self.largeMood setTextHidden:YES animated:NO];
        
        self.addEntry = [[BYCAddEntryView alloc] initWithFrame:CGRectZero];
        self.addEntry.contentOffset = [self layoutLargeMood];
        self.addEntry.mood = type;
        
        [self addSubview:self.addEntry];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];    
    [self layoutLargeMood];
    self.addEntry.frame = self.bounds;
}

-(CGFloat)layoutLargeMood {
    CGFloat largeMoodY = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ? 25 : 5;
    [self.largeMood centerHorizonallyAtY:largeMoodY inBounds:self.bounds thatFits:CGSizeUnbounded];
    return CGRectGetMaxY(self.largeMood.frame)-20;
}

-(void)setNavView:(UIView *)navView {
    [navView addSubview:self.largeMood];
}

-(void)moodView:(BYCMoodView *)view selectedWithType:(BYCMoodType)type {
    [self.largeMood animateStep];
}

-(void)offsetChanged:(CGFloat)percent {
    CGFloat minSize = 34.0f;
    CGFloat faceSize = minSize + (kLargeSize-minSize)*percent;
    
    [self.largeMood stopAnimation];
    self.largeMood.faceSize = faceSize;
    
    [self layoutLargeMood];
}

@end
