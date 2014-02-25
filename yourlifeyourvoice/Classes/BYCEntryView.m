#import "BYCEntryView.h"
#import "BYCMoodView.h"
#import "BYCEntryRowLayoutView.h"
#import "BYCAddEntryView.h"
#import "BYCUI.h"
#import "BYCConstants.h"

#define kLargeSize 190.0f
#define kSmallSize 110.0f

@interface BYCEntryView()<BYCMoodViewDelegate>
@property (nonatomic) BYCEntryRowLayoutView *rowLayout;
@property (nonatomic) BYCMoodView *largeMood;
@property (nonatomic) BYCAddEntryView *addEntry;
@property (nonatomic, weak) id<BYCEntryViewDelegate> delegate;
@end

@implementation BYCEntryView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.rowLayout = [[BYCEntryRowLayoutView alloc] initWithFrame:CGRectZero];
        
        for(int i=0; i<10; i++) {
            BYCMoodView *mood = [[BYCMoodView alloc] initWithFrame:CGRectZero type:BYCMoodView_Lonely];
            mood.faceSize = kSmallSize;
            mood.delegate = self;
            [self.rowLayout addSmallIconView:mood];
        }
        
        self.largeMood = [[BYCMoodView alloc] initWithFrame:CGRectZero type:BYCMoodView_Lonely];
        self.largeMood.userInteractionEnabled = NO;
        self.largeMood.faceSize = kLargeSize;
        [self.largeMood setTextHidden:YES animated:NO];
        self.largeMood.hidden = YES;
        
        self.addEntry = [[BYCAddEntryView alloc] initWithFrame:CGRectZero];
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
    
    CGFloat largeMoodY = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ? 30 : 10;
    [self.largeMood centerHorizonallyAtY:largeMoodY inBounds:self.bounds thatFits:CGSizeUnbounded];
    CGFloat offsetY = CGRectGetMaxY(self.largeMood.frame)-20;
    self.addEntry.frame = CGRectMake(0, offsetY, self.bounds.size.width, self.bounds.size.height-offsetY);
}

-(void)setNavView:(UIView *)navView {
    [navView addSubview:self.largeMood];
}

-(void)moodView:(BYCMoodView*)view selectedWithType:(BYCMoodViewType)type {
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
    [self.addEntry setMoodText:[view moodString]];
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

@end
