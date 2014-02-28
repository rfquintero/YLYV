#import "BYCContentView.h"

@protocol BYCEntryViewDelegate <NSObject>
-(void)entryStarted;
-(void)photoSelected;
-(void)becauseSelected;
-(void)audioSelected;
-(void)saveSelected;
-(void)deleteSelected;
-(void)noteChanged:(NSString*)note;
-(void)setNavActive:(BOOL)active;
@end

@interface BYCEntryView : BYCContentView
-(void)discardEntry;
-(void)setNavView:(UIView*)navView;
-(void)setImage:(UIImage*)image;
-(void)setReasons:(NSArray*)reasons;
-(void)setDelegate:(id<BYCEntryViewDelegate>)delegate;
@end
