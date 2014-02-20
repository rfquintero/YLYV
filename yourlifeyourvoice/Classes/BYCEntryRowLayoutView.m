#import "BYCEntryRowLayoutView.h"
#import "BYCUI.h"

@interface BYCEntryRowLayoutView()
@property(nonatomic, strong) NSNumber *animatedViewIndex;
@property(nonatomic, strong) NSMutableArray *smallIconViews;
@property(nonatomic, strong) UIView *largeIconView;
@property (nonatomic, weak) id<BYCEntryRowLayoutViewDelegate> delegate;
@end

@implementation BYCEntryRowLayoutView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.smallIconViews = [NSMutableArray array];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    CGFloat spacingX = 15.0f;
    CGFloat spacingY = 15.0f;
    CGFloat imageSize = 125.0f;
    
    CGFloat rowInset = (width - 2 * imageSize - spacingX) / 2;
    CGFloat additionalHeight = spacingY;
    
    int animatedRow = [self.animatedViewIndex intValue] / 2;
    animatedRow = animatedRow == 0 ? 1 : animatedRow;
    
    CGSize largeIconSize = [self.largeIconView sizeThatFits:CGSizeUnbounded];
    
    CGFloat xPos = roundf((width - largeIconSize.width) / 2);
    CGFloat yPos = roundf(animatedRow * (imageSize + spacingY) + spacingY / 2);
    
    self.largeIconView.frame = CGRectMake(xPos, yPos, largeIconSize.width, largeIconSize.height);
    self.largeIconView.transform = CGAffineTransformMakeScale(1, 1);
    
    int i = 0;
    for (UIView *view in self.smallIconViews) {
        int currentColumn = i % 2;
        int currentRow = i / 2;
        
        if (self.animatedViewIndex && (currentRow >= animatedRow)) {
            additionalHeight = self.largeIconView.frame.size.height + spacingY;
        }
        CGFloat xPos = roundf(rowInset + (imageSize + spacingX) * currentColumn);
        CGFloat yPos = roundf(currentRow * (imageSize + spacingY) + additionalHeight);
        view.frame = CGRectMake(xPos, yPos, imageSize, imageSize);
        ++i;
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat spacingY = 15.0f;
    CGFloat imageHeight = 125.0f;

    CGSize largeIconSize = [self.largeIconView sizeThatFits:CGSizeUnbounded];
    CGFloat additionalHeight = self.animatedViewIndex ? largeIconSize.height + spacingY : spacingY;
    
    return CGSizeMake(size.width, ((self.smallIconViews.count + 1) / 2) * (spacingY + imageHeight) + additionalHeight);
}

- (void)showLargeView:(UIView *)view forIndex:(NSNumber *)index {
//    for (GluStrengthInNumbersButton *view in self.smallIconViews) {
//        view.selected = NO;
//    }
//    
//    GluStrengthInNumbersButton *smallIconView = [self.smallIconViews objectAtIndex:[index intValue]];
//    smallIconView.selected = YES;
//    
//    [self.largeIconView removeFromSuperview];
//    self.largeIconView = view;
//    self.largeIconView.transform = CGAffineTransformMakeScale(0.5, 0.5);
//    self.largeIconView.center = smallIconView.center;
//    self.largeIconView.alpha = 0;
//    [self addSubview:view];
//    
//    self.animatedViewIndex = index;
//    
//    [UIView animateWithDuration:GluStandardTransitionAnimationLength animations:^{
//        [self layoutSubviews];
//        self.largeIconView.alpha = 1;
//    } completion:^(BOOL finished) {
//        if (finished) {
//            [self.target performSelector:self.action];
//        }
//    }];
}

- (void)hideLargeViewForIndex:(NSNumber *)index {
//    GluStrengthInNumbersButton *smallIconView = [self.smallIconViews objectAtIndex:[index intValue]];
//    smallIconView.selected = NO;
//    
//    UIView *largeIconView = self.largeIconView;
//    self.largeIconView = nil;
//    self.animatedViewIndex = nil;
//    [UIView animateWithDuration:GluStandardTransitionAnimationLength animations:^{
//        [self layoutSubviews];
//        largeIconView.transform = CGAffineTransformMakeScale (0.5, 0.5);
//        largeIconView.center = smallIconView.center;
//        largeIconView.alpha = 0;
//    } completion:^(BOOL finished) {
//        if (finished) {
//            [largeIconView removeFromSuperview];
//            [self.target performSelector:self.action];
//        }
//    }];
}

- (void)addSmallIconView:(UIView *)view {
    [self.smallIconViews addObject:view];
    [self addSubview:view];
}

@end
