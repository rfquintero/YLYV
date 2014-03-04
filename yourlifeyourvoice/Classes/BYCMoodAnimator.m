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
        int i = rand()%self.moodViews.count;
        BYCMoodView *view = self.moodViews[i];
        [view animateStep];
    }
}

-(void)triggerAnimation {
    [self performSelectorOnMainThread:@selector(animate) withObject:nil waitUntilDone:NO];
}

@end
