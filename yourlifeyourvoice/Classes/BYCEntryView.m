#import "BYCEntryView.h"
#import "BYCMoodView.h"
#import "BYCEntryRowLayoutView.h"
#import "BYCUI.h"

@interface BYCEntryView()
@property (nonatomic) BYCEntryRowLayoutView *rowLayout;
@end

@implementation BYCEntryView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.rowLayout = [[BYCEntryRowLayoutView alloc] initWithFrame:CGRectZero];
        
        for(int i=0; i<10; i++) {
            BYCMoodView *mood = [[BYCMoodView alloc] initWithFrame:CGRectZero type:BYCMoodView_Lonely];
            [self.rowLayout addSmallIconView:mood];
        }
        
        [self.scrollView addSubview:self.rowLayout];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self.rowLayout setFrameAtOrigin:CGPointZero thatFits:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX)];
    [self setContentHeight:CGRectGetMaxY(self.rowLayout.frame)];
}

@end
