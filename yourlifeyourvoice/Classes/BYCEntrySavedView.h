#import <UIKit/UIKit.h>

@protocol BYCEntrySavedViewDelegate <NSObject>
-(void)reminderSelected;
-(void)talkSelected;
-(void)moodsSelected;
-(void)infoSelected;
-(void)cancelSelected;
@end

@interface BYCEntrySavedView : UIView
-(void)setStandardTitle:(NSString*)title hideReminders:(BOOL)hideReminders;
-(void)setAlternateTitle:(NSString*)title;
-(void)setDelegate:(id<BYCEntrySavedViewDelegate>)delegate;
@end
