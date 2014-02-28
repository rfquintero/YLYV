#import <UIKit/UIKit.h>

@protocol BYCAddReasonsViewDelegate <NSObject>
-(void)reasonAdded:(NSString*)reason;
-(void)reasonRemoved:(NSString*)reason;
@end

@interface BYCAddReasonsView : UIView
-(void)setReasons:(NSArray*)reasons;
-(void)setDelegate:(id<BYCAddReasonsViewDelegate>)delegate;
@end
