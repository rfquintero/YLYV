#import "BYCMoodSprite.h"
#import "BYCSpriteLayer.h"

@interface BYCMoodSpriteFrame : NSObject
@property (nonatomic) CGRect rect;
@property (nonatomic) BOOL rotated;
@property (nonatomic) NSString *name;
@end

@implementation BYCMoodSpriteFrame
@end

@interface BYCMoodSprite()<BYCSpriteLayerDataSource>
@property (nonatomic) NSArray *frames;
@property (nonatomic) UIImage *image;
@property (nonatomic) CALayer *imageLayer;
@property (nonatomic) BYCSpriteLayer *spriteLayer;
@property (nonatomic) BOOL small;
@property (nonatomic) BYCMoodType type;

@property (nonatomic) NSDictionary *animations;
@property (nonatomic) NSUInteger currentAnimation;
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
        
        [self.layer addSublayer:self.spriteLayer];
        [self.layer addSublayer:self.imageLayer];
    }
    return self;
}

-(void)setType:(BYCMoodType)type {
    _type = type;
    [self.spriteLayer removeAllAnimations];
    [self.imageLayer removeAllAnimations];
    self.imageLayer.contents = nil;
    self.image = nil;
    self.currentAnimation = 0;
    self.animations = [BYCMood animationList:type];
}

-(void)loadImage {
    UIImage *image;
    if(self.small) {
        image = [BYCMood smallSpriteImage:self.type];
        [self processRects:[BYCMood smallPlist:self.type] atlas:image];
    } else {
        image = [BYCMood spriteImage:self.type];
        [self processRects:[BYCMood plist:self.type] atlas:image];
    }
    self.imageLayer.contents = (__bridge id)(image.CGImage);
    [self update:[self frame:0]];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.imageLayer.frame = self.bounds;
    self.spriteLayer.frame = self.bounds;
}

-(void)processRects:(NSDictionary*)dictionary atlas:(UIImage*)image {
    NSMutableArray *rects = [NSMutableArray array];
    NSArray *subimages = dictionary[@"images"][0][@"subimages"];
    for(NSDictionary *subimage in subimages) {
        NSString *str = subimage[@"textureRect"];
        CGRect rect = CGRectFromString(str);
        
        // normalize
        rect.origin.x /= image.size.width;
        rect.origin.y /= image.size.height;
        rect.size.width /= image.size.width;
        rect.size.height /= image.size.height;
        
        BYCMoodSpriteFrame *frame = [[BYCMoodSpriteFrame alloc] init];
        frame.name = subimage[@"name"];
        frame.rect = rect;
        frame.rotated = [subimage[@"textureRotated"] boolValue];
        
        [rects addObject:frame];
    }
    self.frames = [rects sortedArrayWithOptions:0 usingComparator:^NSComparisonResult(BYCMoodSpriteFrame *frame1, BYCMoodSpriteFrame *frame2) {
        return [frame1.name compare:frame2.name];
    }];
}

-(BYCMoodSpriteFrame*)frameAtIndex:(NSUInteger)index {
    if(self.frames.count == 0) {
        BYCMoodSpriteFrame *frame = [[BYCMoodSpriteFrame alloc] init];
        frame.rect = CGRectZero;
        frame.rotated = NO;
        return frame;
    }
    if(index >= self.frames.count) {
        return [self.frames lastObject];
    }
    return self.frames[index];
}

-(CGRect)rectForFrameIndex:(NSUInteger)index {
    return [self frameAtIndex:index].rect;
}

-(CGAffineTransform)transformForIndex:(NSUInteger)index {
    if([self frameAtIndex:index].rotated) {
        return CGAffineTransformMakeRotation(-M_PI/2);
    } else {
        return CGAffineTransformIdentity;
    }
}

-(void)loadCheck {
    if(!self.image) {
        [self loadImage];
    }
}

-(void)animate {
    [self loadCheck];
    if(!self.spriteLayer.animating) {
        CGPoint point = [self nextAnimation];
        [self.spriteLayer animateFrom:[self frame:point.x] to:[self frame:point.y] fps:[self.animations[@"fps"] floatValue]];
    }
}

-(void)animateAll {
    [self loadCheck];
    NSArray *intro = self.animations[@"intro"];
    NSArray *loop = self.animations[@"loop"];
    NSMutableArray *frames = [NSMutableArray array];
    
    for(NSUInteger i=self.currentAnimation; i<intro.count+loop.count; i++) {
        CGPoint point = [self pointForIndex:i];
        if(![[frames lastObject] isEqual:@(point.x)]) {
            [frames addObject:@(point.x)];
        }
        [frames addObject:@(point.y)];
    }
    [self.spriteLayer animateFrames:frames fps:[self.animations[@"fps"] floatValue]];
    self.currentAnimation = intro.count;
}

-(void)resetAnimation {
    [self.spriteLayer removeAllAnimations];
    [self.imageLayer removeAllAnimations];
    self.currentAnimation = 0;
}

-(CGPoint)nextAnimation {
    NSArray *intro = self.animations[@"intro"];
    NSArray *loop = self.animations[@"loop"];
    
    CGPoint point = [self pointForIndex:self.currentAnimation];
    self.currentAnimation += 1;
    if(self.currentAnimation >= intro.count + loop.count) {
        self.currentAnimation = intro.count;
    }
    
    return point;
}

-(CGPoint)pointForIndex:(NSUInteger)index {
    NSArray *intro = self.animations[@"intro"];
    NSArray *loop = self.animations[@"loop"];
    NSInteger loopIndex = index-intro.count;
    if(loopIndex < 0) {
        return CGPointFromString(intro[self.currentAnimation]);
    } else if(loopIndex < loop.count) {
        return CGPointFromString(loop[loopIndex]);
    }
    return CGPointZero;
}

-(void)update:(NSUInteger)index {
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	self.imageLayer.contentsRect = [self rectForFrameIndex:index];
    self.imageLayer.affineTransform = [self transformForIndex:index];
    [CATransaction commit];
}

-(NSUInteger)frame:(NSUInteger)frame {
    if(frame >= self.frames.count) {
        return self.frames.count-1;
    }
    return frame;
}

@end
