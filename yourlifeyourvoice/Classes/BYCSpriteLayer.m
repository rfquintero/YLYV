#import "BYCSpriteLayer.h"

@interface BYCSpriteLayer()<CAAnimationDelegate>
@property (nonatomic) NSUInteger spriteFrame;
@property (nonatomic, readwrite) BOOL animating;
@property (nonatomic, weak) id<BYCSpriteLayerDataSource> dataSource;
@end

@implementation BYCSpriteLayer

-(id)initWithLayer:(id)layer {
    if(self = [super initWithLayer:layer]) {
        if([layer isKindOfClass:BYCSpriteLayer.class]) {
            BYCSpriteLayer *other = (BYCSpriteLayer*)layer;
            self.dataSource = other.dataSource;
        }
    }
    return self;
}

-(void)animateFrames:(NSArray*)frames fps:(CGFloat)fps {
    NSInteger totalFrames = 0;
    if(frames.count > 0) {
        NSInteger start = [frames[0] integerValue];
        for(int i=1; i<frames.count; i++) {
            NSInteger end = [frames[i] integerValue];
            totalFrames += labs(start-end);
            start = end;
        }
    }
    if(totalFrames > 0) {
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"spriteFrame"];
        anim.values = frames;
        anim.duration = totalFrames/fps;
        anim.repeatCount = 1;
        anim.delegate = self;
        [self addAnimation:anim forKey:nil];
    }
}

-(void)animateFrom:(NSUInteger)start to:(NSUInteger)end duration:(CGFloat)duration {
    // Removing this labs breaks the animations...must be a type mismatch somewhere?
    NSUInteger frames = labs(start - end);
    if(start < end) {
        end += 1;
    }
    if(frames > 0) {
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"spriteFrame"];
        anim.fromValue = @(start);
        anim.toValue = @(end);
        anim.duration = duration;
        anim.repeatCount = 1;
        anim.delegate = self;
        
        [self addAnimation:anim forKey:nil];
    }
}

-(void)animateFrom:(NSUInteger)start to:(NSUInteger)end fps:(CGFloat)fps {
    // Removing this labs breaks the animations...must be a type mismatch somewhere?
    NSUInteger frames = labs(start - end);
    if(frames > 0) {
        [self animateFrom:start to:end duration:frames/fps];
    }
}

-(void)setSpriteFrame:(NSUInteger)spriteFrame {
    _spriteFrame = spriteFrame;
    [self.dataSource update:spriteFrame];
}

+(BOOL)needsDisplayForKey:(NSString *)key {
    if([key isEqualToString:@"spriteFrame"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

-(void)animationDidStart:(CAAnimation *)anim {
    self.animating = YES;
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.animating = NO;
}


@end
