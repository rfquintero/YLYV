#import "BYCSpriteLayer.h"

@interface BYCSpriteLayer()
@property (nonatomic) NSUInteger spriteFrame;
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

-(void)animateFrom:(NSUInteger)start to:(NSUInteger)end {
    NSUInteger frames = abs(start - end);
    if(frames > 0) {
        CGFloat fps = 10.0f;
        CGFloat duration = frames/fps;
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"spriteFrame"];
        anim.fromValue = @(start);
        anim.toValue = @(end);
        anim.duration = duration;
        anim.repeatCount = 100;
        
        [self addAnimation:anim forKey:nil];
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


@end
