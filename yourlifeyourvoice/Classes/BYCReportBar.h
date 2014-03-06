#import <UIKit/UIKit.h>
#import "BYCMood.h"

@interface BYCReportBar : UITableViewCell
-(id)initWithReuseIdentifier:(NSString*)identifier;
-(void)setMoodType:(BYCMoodType)type count:(NSUInteger)count percent:(CGFloat)percent;
-(void)animateWithDelay:(CGFloat)delay;
@end
