#import "BYCSpriteLayer.h"

@interface BYCSpriteLayer()
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

-(void)animateFrom:(NSUInteger)start to:(NSUInteger)end duration:(CGFloat)duration {
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
