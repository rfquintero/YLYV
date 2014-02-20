#import <UIKit/UIKit.h>

@protocol BYCEntryRowLayoutViewDelegate<NSObject>

@end

@interface BYCEntryRowLayoutView : UIView
-(void)showLargeView:(UIView *)view forIndex:(NSNumber *)index;
-(void)hideLargeViewForIndex:(NSNumber *)index;
-(void)addSmallIconView:(UIView *)view;
-(void)setDelegate:(id<BYCEntryRowLayoutViewDelegate>)delegate;
@end
