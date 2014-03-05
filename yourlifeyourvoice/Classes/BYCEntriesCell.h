#import <UIKit/UIKit.h>
#import "BYCEntry.h"

@interface BYCEntriesCell : UITableViewCell
-(id)initWithReuseIdentifier:(NSString *)identifier;
-(void)setEntry:(BYCEntry*)entry;
@end
