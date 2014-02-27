#import <UIKit/UIKit.h>

@protocol BYCAddEntryViewDelegate <NSObject>
-(void)addSelected;
-(void)saveSelected;
-(void)deleteSelected;
-(void)offsetChanged:(CGFloat)percent;
-(void)setNavActive:(BOOL)active;
@end

@interface BYCAddEntryView : UIView
@property (nonatomic) CGFloat contentOffset;
-(void)setMoodText:(NSString*)text;
-(void)resetContent;
-(void)setDelegate:(id<BYCAddEntryViewDelegate>)delegate;
@end
