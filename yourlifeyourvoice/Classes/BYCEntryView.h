#import "BYCContentView.h"

@protocol BYCEntryViewDelegate <NSObject>
-(void)entryStarted;
-(void)photoSelected;
-(void)becauseSelected;
-(void)audioSelected;
-(void)saveSelected;
-(void)deleteSelected;
-(void)setNavActive:(BOOL)active;
@end

@interface BYCEntryView : BYCContentView
-(void)discardEntry;
-(void)setNavView:(UIView*)navView;
-(void)setDelegate:(id<BYCEntryViewDelegate>)delegate;
@end
