#import "BYCMoodSprite.h"
#import "BYCSpriteLayer.h"

@interface BYCMoodSprite()<BYCSpriteLayerDataSource>
@property (nonatomic) NSArray *normalizedRects;
@property (nonatomic) NSArray *rotations;
@property (nonatomic) CALayer *imageLayer;
@property (nonatomic) BYCSpriteLayer *spriteLayer;
@property (nonatomic) BOOL small;
@property (nonatomic) NSUInteger currentFrame;
@end

@implementation BYCMoodSprite

-(id)initWithFrame:(CGRect)frame type:(BYCMoodType)type small:(BOOL)small {
    if (self = [super initWithFrame:frame]) {
        self.small = small;
        self.imageLayer = [CALayer layer];
        self.imageLayer.frame = self.bounds;
        self.imageLayer.masksToBounds = YES;
        
        self.spriteLayer = [BYCSpriteLayer layer];
        self.spriteLayer.dataSource = self;
        
        [self setType:type];
        
        self.currentFrame = 0;
        
        [self.layer addSublayer:self.spriteLayer];
        [self.layer addSublayer:self.imageLayer];
    }
    return self;
}

-(void)setType:(BYCMoodType)type {
    [self.spriteLayer removeAllAnimations];
    [self.imageLayer removeAllAnimations];
    
    UIImage *image;
    if(self.small) {
        image = [BYCMood smallSpriteImage:type];
        [self processRects:[BYCMood smallPlist:type] atlas:image];
    } else {
        image = [BYCMood spriteImage:type];
        [self processRects:[BYCMood plist:type] atlas:image];
    }
    
    self.imageLayer.contents = (__bridge id)(image.CGImage);
    self.imageLayer.contentsRect = [self rectForFrameIndex:0];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.imageLayer.frame = self.bounds;
    self.spriteLayer.frame = self.bounds;
}

-(void)processRects:(NSDictionary*)dictionary atlas:(UIImage*)image {
    NSMutableArray *rects = [NSMutableArray array];
    NSMutableArray *rotations = [NSMutableArray array];
    NSArray *subimages = dictionary[@"images"][0][@"subimages"];
    for(NSDictionary *subimage in subimages) {
        NSString *str = subimage[@"textureRect"];
        CGRect rect = CGRectFromString(str);
        
        // normalize
        rect.origin.x /= image.size.width;
        rect.origin.y /= image.size.height;
        rect.size.width /= image.size.width;
        rect.size.height /= image.size.height;
        
        [rects addObject:[NSValue valueWithCGRect:rect]];
        [rotations addObject:subimage[@"textureRotated"]];
    }
    self.normalizedRects = rects;
    self.rotations = rotations;
}

-(CGRect)rectForFrameIndex:(NSUInteger)index {
    return [self.normalizedRects[index] CGRectValue];
}

-(CGAffineTransform)transformForIndex:(NSUInteger)index {
    if([self.rotations[index] boolValue]) {
        return CGAffineTransformMakeRotation(-M_PI/2);
    } else {
        return CGAffineTransformIdentity;
    }
}

-(void)animate {
    [self.spriteLayer animateFrom:0 to:self.normalizedRects.count-1];
}

-(void)update:(NSUInteger)index {
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	self.imageLayer.contentsRect = [self rectForFrameIndex:index];
    self.imageLayer.affineTransform = [self transformForIndex:index];
    [CATransaction commit];
}

@end
