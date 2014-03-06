#import "BYCReportModel.h"

#define kRecentSize 20

@interface  BYCReportItem()
@property (nonatomic, readwrite) BYCMoodType type;
@property (nonatomic, readwrite) NSUInteger count;
@property (nonatomic, readwrite) CGFloat percent;
@end

@implementation BYCReportItem
@end

@interface BYCReportModel()
@property (nonatomic) BYCDatabase *database;
@property (nonatomic) BYCQueue *queue;
@property (nonatomic, readwrite) NSArray *recentEntries;
@property (nonatomic, readwrite) NSArray *allEntries;
@property (nonatomic, readwrite) NSUInteger totalCount;
@end

@implementation BYCReportModel

-(id)initWithDatabase:(BYCDatabase*)database queue:(BYCQueue*)queue {
    if(self = [super init]) {
        self.database = database;
        self.queue = queue;
    }
    return self;
}

-(NSUInteger)recentCount {
    return MIN(kRecentSize, self.totalCount);
}

-(void)calculate {
    [self.queue performAsync:^{
        NSArray *entries = [self.database getAllEntries];
        NSMutableDictionary *recent = [NSMutableDictionary dictionary];
        NSMutableDictionary *all = [NSMutableDictionary dictionary];
        
        int i=0;
        for(BYCEntry *entry in entries) {
            if(i++ < kRecentSize) {
                [self increment:recent type:entry.type];
            }
            [self increment:all type:entry.type];
        }
        
        self.totalCount = entries.count;
        self.recentEntries = [self calculate:recent total:self.recentCount];
        self.allEntries = [self calculate:all total:self.totalCount];
    } callback:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:BYCReportModelFinished object:self];
    } blocking:YES];
}

-(NSArray*)calculate:(NSDictionary*)counts total:(NSUInteger)total {
    NSArray* keys = [counts keysSortedByValueUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        return [obj2 compare:obj1];
    }];
    
    NSMutableArray *items = [NSMutableArray array];
    for(NSNumber* key in keys) {
        BYCReportItem *item = [[BYCReportItem alloc] init];
        item.type = [key intValue];
        item.count = [counts[key] unsignedIntegerValue];
        item.percent = ((CGFloat)item.count/total);
        [items addObject:item];
    }
    return items;
}

-(void)increment:(NSMutableDictionary*)dictionary type:(BYCMoodType)type {
    NSNumber *key = @(type);
    if(!dictionary[key]) {
        dictionary[key] = @(1);
    } else {
        NSUInteger value = [dictionary[key] unsignedIntegerValue];
        dictionary[key] = @(value+1);
    }
}

@end
