#import "BYCEntry.h"
#import "BYCContentView.h"
#import "BYCAddEntryView.h"

@interface BYCEntryDetailsView : BYCContentView
@property (nonatomic, readonly) BYCAddEntryView *addEntry;
-(id)initWithFrame:(CGRect)frame type:(BYCMoodType)type;
-(void)setNavView:(UIView *)navView;
-(void)offsetChanged:(CGFloat)percent;
@end
