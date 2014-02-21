#import <UIKit/UIKit.h>

typedef enum {
    BYCMoodView_Lonely,
} BYCMoodViewType;

@class BYCMoodView;

@protocol BYCMoodViewDelegate <NSObject>
-(void)moodView:(BYCMoodView*)view selectedWithType:(BYCMoodViewType)type;
@end

@interface BYCMoodView : UIView
@property (nonatomic, readonly) NSString *moodString;
@property (nonatomic) CGFloat faceSize;
-(id)initWithFrame:(CGRect)frame type:(BYCMoodViewType)type;
-(void)setTextHidden:(BOOL)hidden animated:(BOOL)animated;
-(void)setTextFont:(UIFont*)font;
-(void)setDelegate:(id<BYCMoodViewDelegate>)delegate;
@end
