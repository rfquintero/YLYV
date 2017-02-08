#import "BYCMoodAnimator.h"
#import "BYCMoodView.h"

@interface BYCMoodAnimator()
@property (nonatomic) NSTimer *timer;
@end

@implementation BYCMoodAnimator

-(id)init {
    if(self = [super init]) {
        self.delay = 1.5f;
    }
    return self;
}

-(id)initWithViews:(NSArray*)views delay:(CGFloat)delay {
    if(self = [super init]) {
        self.delay = delay;
        self.moodViews = views;
    }
    return self;
}

-(void)setTimer:(NSTimer *)timer {
    [_timer invalidate];
    _timer = timer;
}

-(void)start {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.delay target:self selector:@selector(triggerAnimation) userInfo:nil repeats:YES];
}

-(void)stop {
    self.timer = nil;
}

-(void)animateNext {
    [self stop];
    [self animate];
    [self start];
}

-(void)animate {
    if(self.moodViews.count > 0) {
        NSRange range = [self.delegate animatorVisibleRange:self];
        NSInteger index = 0;
        if(range.length > 0) {
            index = (range.location + rand()%range.length);
        } else {
            index = rand()%self.moodViews.count;
        }
        index = MAX(0, MIN(self.moodViews.count-1, index));
        BYCMoodView *view = self.moodViews[index];
        [view animateStep];
    }
}

-(void)triggerAnimation {
    [self performSelectorOnMainThread:@selector(animate) withObject:nil waitUntilDone:NO];
}

@end
