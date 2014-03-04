#import <Foundation/Foundation.h>

@interface BYCMoodAnimator : NSObject
@property (nonatomic) NSArray *moodViews;
@property (nonatomic) CGFloat delay;
-(id)initWithViews:(NSArray*)views delay:(CGFloat)delay;
-(void)start;
-(void)stop;
-(void)animateNext;
@end
