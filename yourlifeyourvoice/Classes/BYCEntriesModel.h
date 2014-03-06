#import <Foundation/Foundation.h>
#import "BYCDatabase.h"
#import "BYCQueue.h"

#define BYCEntriesModelRefreshed @"BYCEntriesModelRefreshed"

@interface BYCEntriesModel : NSObject
@property (nonatomic, readonly) NSArray *entries;
@property (nonatomic, readonly) BOOL hasMore;
-(id)initWithDatabase:(BYCDatabase*)database queue:(BYCQueue*)queue;
-(void)nextPage;
-(void)updateEntry:(BYCEntry*)entry with:(BYCEntry*)newEntry;
-(void)removeEntry:(BYCEntry*)entry;
@end
