#import <UIKit/UIKit.h>
#import "BYCEntry.h"

@protocol BYCEntriesViewDelegate <NSObject>
-(void)loadMore;
-(void)entrySelected:(BYCEntry*)entry;
@end

@interface BYCEntriesView : UIView
-(void)setEntries:(NSArray*)entries hasMore:(BOOL)hasMore;
-(void)setDelegate:(id<BYCEntriesViewDelegate>)delegate;
@end
