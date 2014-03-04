#import <QuartzCore/QuartzCore.h>

@protocol BYCSpriteLayerDataSource <NSObject>
-(void)update:(NSUInteger)index;
@end

@interface BYCSpriteLayer : CALayer
@property (nonatomic, readonly) BOOL animating;
-(void)animateFrames:(NSArray*)frames fps:(CGFloat)fps;
-(void)animateFrom:(NSUInteger)start to:(NSUInteger)end duration:(CGFloat)duration;
-(void)animateFrom:(NSUInteger)start to:(NSUInteger)end fps:(CGFloat)fps;
-(void)setDataSource:(id<BYCSpriteLayerDataSource>)dataSource;
@end
