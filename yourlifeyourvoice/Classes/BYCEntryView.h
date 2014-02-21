#import "BYCContentView.h"

@protocol BYCEntryViewDelegate <NSObject>
-(void)entryStarted;
@end

@interface BYCEntryView : BYCContentView
-(void)discardEntry;
-(void)setDelegate:(id<BYCEntryViewDelegate>)delegate;
@end
