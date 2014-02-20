#import "BYCViewController.h"

@interface BYCViewController ()
@property (nonatomic, readwrite) BYCApplicationState *applicationState;
@end

@implementation BYCViewController

-(id)initWithApplicationState:(BYCApplicationState*)applicationState {
    if(self = [super init]) {
        self.applicationState = applicationState;
    }
    return self;
}

@end
