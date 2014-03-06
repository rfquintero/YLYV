#import <Foundation/Foundation.h>

@protocol  BYCReportViewDelegate <NSObject>
-(void)recentSelected;
-(void)allSelected;
@end

@interface BYCReportView : UIView
-(void)setRecentCount:(NSUInteger)count allCount:(NSUInteger)allCount;
-(void)setReportItems:(NSArray*)items recent:(BOOL)recent;
-(void)setBottomBarFaded:(BOOL)faded animated:(BOOL)animated;
-(void)setDelegate:(id<BYCReportViewDelegate>)delegate;
@end
