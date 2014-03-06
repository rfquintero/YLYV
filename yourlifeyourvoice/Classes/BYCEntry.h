#import <Foundation/Foundation.h>
#import "BYCMood.h"

@interface BYCEntry : NSObject
@property (nonatomic, readonly) int64_t uid;
@property (nonatomic, readonly) BYCMoodType type;
@property (nonatomic, readonly) NSString *note;
@property (nonatomic, readonly) NSArray *reasons;
@property (nonatomic, readonly) NSDate *createdAt;
@property (nonatomic, readonly) UIImage *image;
@property (nonatomic, readonly) NSURL *audioFile;

+(instancetype)entryWithId:(int64_t)uid type:(BYCMoodType)type note:(NSString*)note reasons:(NSArray*)reasons createdAt:(NSDate*)date;

+(NSString*)audioPathForEntryId:(int64_t)uid;
+(NSString*)imagePathForEntryId:(int64_t)uid;
+(void)createDirectories;
@end
