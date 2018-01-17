#import <UIKit/UIKit.h>

@class BYCAccordionView;

@protocol BYCAccordionViewDelegate
-(void)accordionView:(BYCAccordionView*)view tappedWhenShowing:(BOOL)showing;
@end

@interface BYCAccordionView : UIView
@property (nonatomic, weak) id<BYCAccordionViewDelegate> delegate;

-(void)setTitle:(NSString*)title text:(NSString*)text;
-(void)setShowing:(BOOL)showing animated:(BOOL)animated;
@end
