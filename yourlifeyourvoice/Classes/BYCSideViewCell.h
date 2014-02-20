#import <UIKit/UIKit.h>

@interface BYCSideViewCell : UITableViewCell
-(id)initWithReuseIdentifier:(NSString*)identifier;
-(void)setCellSelected:(BOOL)selected;
-(void)setTitleText:(NSString*)text;
+(CGFloat)heightForCellWithWidth:(CGFloat)width text:(NSString*)text;
@end
