#import <UIKit/UIKit.h>

@protocol BYCAddEntryViewDelegate <NSObject>
-(void)addSelected;
-(void)saveSelected;
-(void)deleteSelected;
@end

@interface BYCAddEntryView : UIView
-(void)setMoodText:(NSString*)text;
-(void)setDelegate:(id<BYCAddEntryViewDelegate>)delegate;
@end
