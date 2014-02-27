#import <UIKit/UIKit.h>

@protocol BYCAddEntryViewDelegate <NSObject>
-(void)addSelected;
-(void)saveSelected;
-(void)deleteSelected;
-(void)offsetChanged:(CGFloat)percent;
@end

@interface BYCAddEntryView : UIView
@property (nonatomic) CGFloat contentOffset;
-(void)setMoodText:(NSString*)text;
-(void)resetContent;
-(void)setDelegate:(id<BYCAddEntryViewDelegate>)delegate;
@end
