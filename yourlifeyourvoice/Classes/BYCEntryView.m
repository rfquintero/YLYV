#import "BYCEntryView.h"
#import "BYCMoodView.h"
#import "BYCEntryRowLayoutView.h"
#import "BYCAddEntryView.h"
#import "BYCUI.h"
#import "BYCConstants.h"

#define kLargeSize 190.0f
#define kSmallSize 110.0f

@interface BYCEntryView()<BYCMoodViewDelegate, BYCAddEntryViewDelegate>
@property (nonatomic) BYCEntryRowLayoutView *rowLayout;
@property (nonatomic) BYCMoodView *largeMood;
@property (nonatomic) BYCAddEntryView *addEntry;
@property (nonatomic) UIButton *blocker;
@property (nonatomic, weak) id<BYCEntryViewDelegate> delegate;
@end

@implementation BYCEntryView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.rowLayout = [[BYCEntryRowLayoutView alloc] initWithFrame:CGRectZero];
        
        self.blocker = [UIButton buttonWithType:UIButtonTypeCustom];

        
        for(NSNumber *type in self.moods) {
            BYCMoodView *mood = [[BYCMoodView alloc] initWithFrame:CGRectZero type:[type intValue]];
            mood.faceSize = kSmallSize;
            mood.delegate = self;
            [self.rowLayout addSmallIconView:mood];
        }
        
        self.largeMood = [[BYCMoodView alloc] initWithFrame:CGRectZero type:BYCMood_Lonely];
        self.largeMood.userInteractionEnabled = NO;
        self.largeMood.faceSize = kLargeSize;
        [self.largeMood setTextHidden:YES animated:NO];
        self.largeMood.hidden = YES;
        
        self.addEntry = [[BYCAddEntryView alloc] initWithFrame:CGRectZero];
        self.addEntry.delegate = self;
        self.addEntry.contentOffset = [self layoutLargeMood];;
        [self setAddEntryHidden:YES animated:NO];
        
        [self.scrollView addSubview:self.rowLayout];
        [self addSubview:self.addEntry];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self.rowLayout setFrameAtOrigin:CGPointZero thatFits:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX)];
    [self setContentHeight:CGRectGetMaxY(self.rowLayout.frame)];
    
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

-(void)moodView:(BYCMoodView*)view selectedWithType:(BYCMoodType)type {
    [self.largeMood setType:type];
    
    CGRect start = [self.scrollView convertRect:view.frame fromView:self.rowLayout];
    CGRect end = self.largeMood.frame;
    CGPoint center = self.rowLayout.center;
    CGFloat scale = kLargeSize/kSmallSize;

    CGFloat newX = center.x - scale*(center.x-start.origin.x);
    CGFloat newY = center.y - scale*(center.y-start.origin.y);

    CGFloat tx = end.origin.x - newX;
    CGFloat ty = (end.origin.y+self.scrollView.contentOffset.y) - newY;
    
    [view setTextHidden:YES animated:NO];
    [self.delegate entryStarted];
    [self.addEntry setMoodText:[BYCMood moodString:type]];
    [UIView animateWithDuration:0.3f animations:^{
        self.rowLayout.transform = CGAffineTransformMake(scale, 0.f, 0.f, scale, tx, ty);
        for(UIView *icon in self.rowLayout.icons) {
            if(icon != view) {
                icon.alpha = 0.0f;
            }
        }
    } completion:^(BOOL finished) {
        self.largeMood.hidden = NO;
        self.rowLayout.hidden = YES;
        self.scrollView.scrollEnabled = NO;
        [self setAddEntryHidden:NO animated:YES];
    }];
}

-(void)discardEntry {
    self.largeMood.hidden = YES;
    self.rowLayout.hidden = NO;
    self.scrollView.scrollEnabled = YES;
    
    [self setAddEntryHidden:YES animated:YES];
    
    [UIView animateWithDuration:0.3f delay:0.3f options:0 animations:^{
        self.rowLayout.transform = CGAffineTransformIdentity;
        for(BYCMoodView *icon in self.rowLayout.icons) {
            icon.alpha = 1.0f;
            [icon setTextHidden:NO animated:NO];
        }
    } completion:^(BOOL finished) {
        [self.addEntry resetContent];
    }];
}

-(void)setAddEntryHidden:(BOOL)hidden animated:(BOOL)animated {
    if(animated) {
        self.addEntry.hidden = NO;
        [UIView animateWithDuration:0.3f animations:^{
            self.addEntry.alpha = hidden ? 0.0f : 1.0f;
        } completion:^(BOOL finished) {
            self.addEntry.hidden = hidden;
        }];
    } else {
        self.addEntry.alpha = hidden ? 0.0f : 1.0f;
        self.addEntry.hidden = hidden;
    }
}

#pragma mark BYCAddEntryViewDelegate

-(void)addSelected {
    
}

-(void)saveSelected {
    
}

-(void)deleteSelected {
    
}

-(void)offsetChanged:(CGFloat)percent {
    CGFloat minSize = 34.0f;
    CGFloat faceSize = minSize + (kLargeSize-minSize)*percent;
    
    [self.largeMood animate:NO];
    self.largeMood.faceSize = faceSize;
    
    [self layoutLargeMood];
}

#pragma mark moods

-(NSArray*)moods {
    return @[@(BYCMood_Happy), @(BYCMood_Relieved), @(BYCMood_Confident), @(BYCMood_Proud), @(BYCMood_Depressed),
             @(BYCMood_Lonely), @(BYCMood_Invisible), @(BYCMood_Embarassed), @(BYCMood_Stressed), @(BYCMood_Confused),
             @(BYCMood_Angry), @(BYCMood_Frustrated)];
}

@end
