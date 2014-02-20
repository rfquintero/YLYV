#import <UIKit/UIKit.h>

@protocol BYCSideViewDelegate <NSObject>
-(void)hideSidebar;
@end

@interface BYCSideView : UIView
-(void)setDelegate:(id<BYCSideViewDelegate>)delegate;
@end
