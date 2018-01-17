#import <UIKit/UIKit.h>
#import "BYCContentView.h"

@protocol BYCSafetyPlanViewDelegate
-(void)emailSelected;
-(void)exampleSelected;
@end

@interface BYCSafetyPlanView : BYCContentView
@property (nonatomic, weak) id<BYCSafetyPlanViewDelegate> delegate;
@end
