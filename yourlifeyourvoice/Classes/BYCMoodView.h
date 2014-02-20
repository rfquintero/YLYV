#import <UIKit/UIKit.h>

typedef enum {
    BYCMoodView_Lonely,
} BYCMoodViewType;

@interface BYCMoodView : UIView
@property (nonatomic, readonly) NSString *moodString;
-(id)initWithFrame:(CGRect)frame type:(BYCMoodViewType)type;
-(void)setTextHidden:(BOOL)hidden animated:(BOOL)animated;
-(void)setTextFont:(UIFont*)font;
@end
