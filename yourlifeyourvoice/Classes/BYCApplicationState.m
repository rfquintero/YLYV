#import "BYCApplicationState.h"

@interface BYCApplicationState()
@property (nonatomic, readwrite) BYCDatabase* database;
@property (nonatomic, readwrite) BYCQueue *queue;
@end

@implementation BYCApplicationState

-(id)initWithBlocker:(BYCTouchBlocker*)blocker {
    if(self = [super init]) {
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"db.sqlite"];
        self.database = [[BYCDatabase alloc] initWithDatabasePath:dbPath];
        
        self.queue = [[BYCQueue alloc] initWithQueue:[[NSOperationQueue alloc] init] blocker:blocker];
    }
    return self;
}

@end
