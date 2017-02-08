#import <UIKit/UIKit.h>

@protocol BYCEntryRowLayoutViewDelegate<NSObject>

@end

@interface BYCEntryRowLayoutView : UIView
@property (nonatomic, readonly) NSArray *icons;

-(void)addSmallIconView:(UIView *)view;
-(void)setDelegate:(id<BYCEntryRowLayoutViewDelegate>)delegate;
-(NSInteger)rowAtOffset:(CGFloat)offsetY;
@end
