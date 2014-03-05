#import <UIKit/UIKit.h>

@protocol BYCSideViewDelegate <NSObject>
-(void)hideSidebar;
-(void)entrySelected;
-(void)moodsSelected;
-(void)talkSelected;
@end

@interface BYCSideView : UIView
-(void)setDelegate:(id<BYCSideViewDelegate>)delegate;
@end
