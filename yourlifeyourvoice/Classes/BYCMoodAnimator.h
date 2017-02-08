#import <Foundation/Foundation.h>

@class BYCMoodAnimator;

@protocol BYCMoodAnimatorDelegate <NSObject>
-(NSRange)animatorVisibleRange:(BYCMoodAnimator*)animator;
@end

@interface BYCMoodAnimator : NSObject
@property (nonatomic, weak) id<BYCMoodAnimatorDelegate> delegate;
@property (nonatomic) NSArray *moodViews;
@property (nonatomic) CGFloat delay;
-(id)initWithViews:(NSArray*)views delay:(CGFloat)delay;
-(void)start;
-(void)stop;
-(void)animateNext;
@end
