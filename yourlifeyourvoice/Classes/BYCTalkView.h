#import "BYCContentView.h"

@protocol BYCTalkViewDelegate <NSObject>
-(void)callSelected;
-(void)emailSelected;
-(void)chatSelected;
-(void)textSelected;
-(void)siteSelected;
@end

@interface BYCTalkView : BYCContentView
-(void)setDelegate:(id<BYCTalkViewDelegate>)delegate;
@end
