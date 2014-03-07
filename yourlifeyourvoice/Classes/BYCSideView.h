#import <UIKit/UIKit.h>

@protocol BYCSideViewDelegate <NSObject>
-(void)hideSidebar;
-(void)entrySelected;
-(void)moodsSelected;
-(void)reportsSelected;
-(void)reminderSelected;
-(void)tipsSelected;
-(void)talkSelected;
-(void)infoSelected;
@end

@interface BYCSideView : UIView
-(void)setDelegate:(id<BYCSideViewDelegate>)delegate;
@end
