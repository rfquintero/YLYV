#import <UIKit/UIKit.h>
#import "BYCMood.h"

@protocol BYCEntrySavedViewDelegate <NSObject>
-(void)reminderSelected;
-(void)talkSelected;
-(void)moodsSelected;
-(void)infoSelected;
-(void)cancelSelected;
-(void)tipsSelected;
-(void)callSelected;
@end

@interface BYCEntrySavedView : UIView
-(void)setMoodCategory:(BYCMoodCategory)category title:(NSString*)title moodString:(NSString*)moodString hideReminders:(BOOL)hideReminders;
-(void)setDelegate:(id<BYCEntrySavedViewDelegate>)delegate;
@end
