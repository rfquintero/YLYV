#import "BYCEntry.h"

@interface BYCEntry()
@property (nonatomic, readwrite) int64_t uid;
@property (nonatomic, readwrite) BYCMoodType type;
@property (nonatomic, readwrite) NSString *note;
@property (nonatomic, readwrite) NSArray *reasons;
@property (nonatomic, readwrite) NSDate *createdAt;
@property (nonatomic, readwrite) UIImage *image;
@property (nonatomic, readwrite) NSString *imagePath;
@property (nonatomic, readwrite) NSURL *audioFile;
@end

@implementation BYCEntry
+(instancetype)entryWithId:(int64_t)uid type:(BYCMoodType)type note:(NSString*)note reasons:(NSArray*)reasons createdAt:(NSDate *)date {
    BYCEntry *entry = [[BYCEntry alloc] init];
    entry.uid = uid;
    entry.type = type;
    entry.note = note;
    entry.reasons = reasons;
    entry.createdAt = date;
    entry.legacyAudio = NO;
    
    NSString *audioPath = [self audioPathForEntryId:uid];
    NSString *wavPath = [self legacyAudioPathForEntryId:uid];
    NSString *imagePath = [self imagePathForEntryId:uid];
    NSFileManager *manager = [NSFileManager defaultManager];
    if([manager fileExistsAtPath:audioPath]) {
        entry.audioFile = [NSURL fileURLWithPath:audioPath];
    } else if([manager fileExistsAtPath:wavPath]) {
        entry.audioFile = [NSURL fileURLWithPath:wavPath];
        entry.legacyAudio = YES;
    }
    if([manager fileExistsAtPath:imagePath]) {
        entry.image = [UIImage imageWithContentsOfFile:imagePath];
        entry.imagePath = imagePath;
    }
    return entry;
}

+(NSString*)audioPathForEntryId:(int64_t)uid withExtension:(NSString*)extension {
    NSString *file = [NSString stringWithFormat:@"%010lli.%@", uid, extension];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"audio"];
    return [path stringByAppendingPathComponent:file];
}

+(NSString*)audioPathForEntryId:(int64_t)uid {
    return [self audioPathForEntryId:uid withExtension:@"ima4"];
}

+(NSString*)legacyAudioPathForEntryId:(int64_t)uid {
    return [self audioPathForEntryId:uid withExtension:@"wav"];
}

+(NSString*)imagePathForEntryId:(int64_t)uid {
    NSString *file = [NSString stringWithFormat:@"%010lli.jpg", uid];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"images"];
    return [path stringByAppendingPathComponent:file];
}

+(void)createDirectories {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    [manager createDirectoryAtPath:[documentsDirectory stringByAppendingPathComponent:@"images"] withIntermediateDirectories:YES attributes:nil error:nil];
    [manager createDirectoryAtPath:[documentsDirectory stringByAppendingPathComponent:@"audio"] withIntermediateDirectories:YES attributes:nil error:nil];
}

@end
