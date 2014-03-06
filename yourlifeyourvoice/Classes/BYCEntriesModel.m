#import "BYCEntriesModel.h"

@interface BYCEntriesModel()
@property (nonatomic) BYCDatabase *database;
@property (nonatomic) BYCQueue *queue;
@property (nonatomic) NSUInteger page;
@property (nonatomic, readwrite) NSMutableArray *entriesM;
@property (nonatomic, readwrite) BOOL hasMore;
@end

@implementation BYCEntriesModel

-(id)initWithDatabase:(BYCDatabase*)database queue:(BYCQueue*)queue {
    if(self = [super init]) {
        self.database = database;
        self.queue = queue;
        self.page = 0;
        
        self.entriesM = [NSMutableArray array];
    }
    return self;
}

-(void)nextPage {
    [self.queue performAsync:^{
        NSArray *nextPage = [self.database getEntryPage:self.page];
        [self.entriesM addObjectsFromArray:nextPage];
        self.hasMore = nextPage.count == 20;
    } callback:^{
        self.page += 1;
        [[NSNotificationCenter defaultCenter] postNotificationName:BYCEntriesModelRefreshed object:self];
    } blocking:NO];
}

-(NSArray*)entries {
    return self.entriesM;
}

-(void)updateEntry:(BYCEntry*)entry with:(BYCEntry*)newEntry {
    NSUInteger index = [self.entriesM indexOfObject:entry];
    [self.entriesM replaceObjectAtIndex:index withObject:newEntry];
}

-(void)removeEntry:(BYCEntry*)entry {
    [self.entriesM removeObject:entry];
}

@end
