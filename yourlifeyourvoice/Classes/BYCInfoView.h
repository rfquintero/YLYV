#import "BYCContentView.h"

@protocol BYCInfoViewDelegate <NSObject>
-(void)talkSelected;
-(void)siteSelected;
@end

@interface BYCInfoView : BYCContentView
-(void)setDelegate:(id<BYCInfoViewDelegate>)delegate;
@end
