#import "BYCEntryModel.h"

@interface BYCEntryModel()
@property (nonatomic) NSMutableArray *reasonsM;
@end

@implementation BYCEntryModel

-(id)init {
    if(self = [super init]) {
        self.reasonsM = [NSMutableArray array];
    }
    return self;
}

-(void)addReason:(NSString *)reason {
    if(![self.reasonsM containsObject:reason]) {
        [self.reasonsM addObject:reason];
    }
}

-(void)removeReason:(NSString*)reason {
    [self.reasonsM removeObject:reason];
}

-(NSArray*)reasons {
    return self.reasonsM;
}

@end
