#import "BYCContentView.h"
#import "BYCReminderTime.h"

@protocol BYCReminderViewDelegate <NSObject>
-(void)timeSelected:(NSDate*)time;
-(void)activeChanged:(BOOL)active;
@end

@interface BYCReminderView : BYCContentView
-(void)setTime:(BYCReminderTime*)time;
-(void)setActive:(BOOL)active;
-(void)setDelegate:(id<BYCReminderViewDelegate>)delegate;
@end
