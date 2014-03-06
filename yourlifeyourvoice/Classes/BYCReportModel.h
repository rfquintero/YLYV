#import <Foundation/Foundation.h>
#import "BYCDatabase.h"
#import "BYCQueue.h"

#define BYCReportModelFinished @"BYCReportModelFinished"

@interface BYCReportItem : NSObject
@property (nonatomic, readonly) BYCMoodType type;
@property (nonatomic, readonly) NSUInteger count;
@property (nonatomic, readonly) CGFloat percent;
@end

@interface BYCReportModel : NSObject
@property (nonatomic, readonly) NSArray *recentEntries;
@property (nonatomic, readonly) NSArray *allEntries;
@property (nonatomic, readonly) NSUInteger totalCount;
@property (nonatomic, readonly) NSUInteger recentCount;

-(id)initWithDatabase:(BYCDatabase*)database queue:(BYCQueue*)queue;
-(void)calculate;
@end
