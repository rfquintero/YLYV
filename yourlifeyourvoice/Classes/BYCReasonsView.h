#import <UIKit/UIKit.h>

@interface BYCReasonsView : UIView
@property (nonatomic, readonly) BOOL hasContent;
-(void)setReasons:(NSArray*)reasons;
@end
