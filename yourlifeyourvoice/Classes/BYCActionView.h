#import <UIKit/UIKit.h>

@protocol BYCActionViewDelegate <NSObject>
-(void)actionSelectedWithTag:(NSInteger)tag;
@end

@interface BYCActionView : UIView
-(void)addTitle:(NSString*)title withTag:(NSInteger)tag;
-(void)setDelegate:(id<BYCActionViewDelegate>)delegate;
@end
