#import <QuartzCore/QuartzCore.h>

@protocol BYCSpriteLayerDataSource <NSObject>
-(void)update:(NSUInteger)index;
@end

@interface BYCSpriteLayer : CALayer
-(void)animateFrom:(NSUInteger)start to:(NSUInteger)end;
-(void)setDataSource:(id<BYCSpriteLayerDataSource>)dataSource;
@end
