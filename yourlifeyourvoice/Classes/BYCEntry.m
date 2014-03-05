#import "BYCEntry.h"

@interface BYCEntry()
@property (nonatomic, readwrite) int64_t uid;
@property (nonatomic, readwrite) BYCMoodType type;
@property (nonatomic, readwrite) NSString *note;
@property (nonatomic, readwrite) NSArray *reasons;
@property (nonatomic, readwrite) UIImage *image;
@property (nonatomic, readwrite) NSURL *audioFile;
@end

@implementation BYCEntry
+(instancetype)entryWithId:(int64_t)uid type:(BYCMoodType)type note:(NSString*)note reasons:(NSArray*)reasons {
    BYCEntry *entry = [[BYCEntry alloc] init];
    entry.uid = uid;
    entry.type = type;
    entry.note = note;
    entry.reasons = reasons;
    
    NSString *audioPath = [self audioPathForEntryId:uid];
    NSString *imagePath = [self imagePathForEntryId:uid];
    NSFileManager *manager = [NSFileManager defaultManager];
    if([manager fileExistsAtPath:audioPath]) {
        entry.audioFile = [NSURL fileURLWithPath:audioPath];
    }
    if([manager fileExistsAtPath:imagePath]) {
        entry.image = [UIImage imageWithContentsOfFile:imagePath];
    }
    return entry;
}

+(NSString*)audioPathForEntryId:(int64_t)uid {
    NSString *file = [NSString stringWithFormat:@"%010lli.ima4", uid];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"audio"];
    return [path stringByAppendingPathComponent:file];
}

+(NSString*)imagePathForEntryId:(int64_t)uid {
    NSString *file = [NSString stringWithFormat:@"%010lli.jpg", uid];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"image"];
    return [path stringByAppendingPathComponent:file];
}

@end
