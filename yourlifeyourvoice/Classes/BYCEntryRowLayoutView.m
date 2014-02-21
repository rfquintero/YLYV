#import "BYCEntryRowLayoutView.h"
#import "BYCUI.h"

@interface BYCEntryRowLayoutView()
@property(nonatomic, strong) NSMutableArray *smallIconViews;
@property (nonatomic, weak) id<BYCEntryRowLayoutViewDelegate> delegate;
@end

@implementation BYCEntryRowLayoutView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.smallIconViews = [NSMutableArray array];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    CGSize imageSize = self.viewSize;
    CGFloat spacingY = 15.0f;
    CGFloat spacingX = roundf((width-2*imageSize.width)/3);
    
    int i = 0;
    for (UIView *view in self.smallIconViews) {
        int currentColumn = i % 2;
        int currentRow = i / 2;
        
        CGFloat x = spacingX + currentColumn*(imageSize.width+spacingX);
        CGFloat y = spacingY + currentRow * (imageSize.height + spacingY);
        view.frame = CGRectMake(x, y, imageSize.width, imageSize.height);
        ++i;
    }
}

-(CGSize)viewSize {
    if(self.smallIconViews.count > 0) {
        return [(UIView*)self.smallIconViews[0] sizeThatFits:CGSizeUnbounded];
    } else {
        return CGSizeZero;
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat spacingY = 15.0f;
    CGSize imageSize = self.viewSize;
    
    return CGSizeMake(size.width, ((self.smallIconViews.count + 1) / 2) * (spacingY + imageSize.height));
}

- (void)addSmallIconView:(UIView *)view {
    [self.smallIconViews addObject:view];
    [self addSubview:view];
}

-(NSArray*)icons {
    return self.smallIconViews;
}

@end
