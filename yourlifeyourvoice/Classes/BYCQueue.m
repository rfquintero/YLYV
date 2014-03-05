#import "BYCQueue.h"

@interface BYCOperation : NSOperation
@property (nonatomic, copy) void(^block)();
@property (nonatomic, copy) void(^callback)();
@property (nonatomic) BOOL blocking;
@end

@implementation BYCOperation
-(void)main {
    self.block();
}

-(void)performCallback {
    self.callback();
}
@end

@interface BYCQueue()
@property (nonatomic) NSOperationQueue *queue;
@property (nonatomic) BYCTouchBlocker *blocker;
@end

@implementation BYCQueue

-(id)initWithQueue:(NSOperationQueue *)queue blocker:(BYCTouchBlocker *)blocker {
    if(self = [super init]) {
        self.queue = queue;
        self.blocker = blocker;
    }
    return self;
}

-(void)performAsync:(void(^)())block callback:(void(^)())callback blocking:(BOOL)blocking  {
    BYCOperation *op = [[BYCOperation alloc] init];
    op.block = block;
    op.callback = callback;
    op.blocking = blocking;
    [self queueOperation:op];
}

-(void)queueOperation:(BYCOperation*)operation {
    __block BYCOperation* op = operation;
    if(operation.blocking) {
        [self.blocker show:YES];
    }
    [operation setCompletionBlock:^{
        [self performSelectorOnMainThread:@selector(performCallback:) withObject:op waitUntilDone:NO];
    }];
    [self.queue addOperation:operation];
}

-(void)performCallback:(BYCOperation*)operation {
    BOOL blocking = NO;
    for(BYCOperation *op in self.queue.operations) {
        if(op != operation && op.blocking) {
            blocking = YES;
            break;
        }
    }
    [self.blocker show:blocking];
    [operation performCallback];
}

@end
