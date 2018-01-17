#import <UIKit/UIKit.h>

typedef enum {
    BYCSideView_Entry,
    BYCSideView_Moods,
    BYCSideView_Reports,
    BYCSideView_Reminders,
    BYCSideView_Tips,
    BYCSideView_Talk,
    BYCSideView_Info,
    BYCSideView_SafetyPlan,
} BYCSideViewItem;

@protocol BYCSideViewDelegate <NSObject>
-(void)hideSidebar;
-(void)entrySelected;
-(void)moodsSelected;
-(void)reportsSelected;
-(void)reminderSelected;
-(void)tipsSelected;
-(void)talkSelected;
-(void)infoSelected;
-(void)safetyPlanSelected;
@end

@interface BYCSideView : UIView
-(void)setSelectedMenuItem:(BYCSideViewItem)item;
-(void)setDelegate:(id<BYCSideViewDelegate>)delegate;
@end
