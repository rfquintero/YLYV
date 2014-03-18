#import "BYCMigrationModel.h"
#import "BYCLegacyDatabase.h"
#import "UIImage+Custom.h"

#define checkType(OBJ, TYPE, ASSIGN) \
if([OBJ isKindOfClass:TYPE.class]) {\
ASSIGN;\
} else {\
    return;\
}

@interface BYCMigrationEntry : NSObject
@property (nonatomic) BYCEntry *entry;
@property (nonatomic) NSString *imagePath;
@property (nonatomic) NSString *audioPath;
@end

@implementation BYCMigrationEntry
+(instancetype)entryWithEntry:(BYCEntry*)entry imagePath:(NSString*)imagePath audioPath:(NSString*)audioPath {
    BYCMigrationEntry *object = [[BYCMigrationEntry alloc] init];
    object.entry = entry;
    object.imagePath = imagePath;
    object.audioPath = audioPath;
    return object;
}
@end

@interface BYCMigrationModel()
@property (nonatomic) BYCDatabase *database;
@property (nonatomic) BYCQueue *queue;
@end

@implementation BYCMigrationModel

-(id)initWithDatabase:(BYCDatabase*)database queue:(BYCQueue*)queue {
    if(self = [super init]) {
        self.database = database;
        self.queue = queue;
    }
    return self;
}

-(void)performMigration:(void(^)())completion {
    [self.queue performAsync:^{
        NSMutableDictionary *entries = [NSMutableDictionary dictionary];
        NSFileManager *manager = [NSFileManager defaultManager];
        
        for(NSString *path in [BYCMigrationModel allPaths]) {
            if([manager fileExistsAtPath:path]) {
                BYCLegacyDatabase *db = [[BYCLegacyDatabase alloc] initWithDatabasePath:path];
                [self processEntries:[db getEntries] intoDictionary:entries];
            }
        }
        [self commitEntries:entries];
        sleep(2);
    } callback:^{
        completion();
    } blocking:YES];
}

-(void)processEntries:(NSArray*)array intoDictionary:(NSMutableDictionary*)entries {
    for(BYCLegacyEntry *entry in array) {
        if(entry.value) {
            BYCLegacyEntry *dupe = [entries valueForKey:entry.value];
            if(!dupe || [dupe.key compare:entry.key] == NSOrderedDescending) {
                entries[entry.value] = entry;
            }
        }
    }
}

-(void)commitEntries:(NSDictionary*)entries {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"M.d.yyyy";
    
    NSArray *keys = [entries keysSortedByValueUsingComparator:^NSComparisonResult(BYCLegacyEntry *left, BYCLegacyEntry *right) {
        return [left.key compare:right.key];
    }];
    
    NSMutableDictionary *values = [NSMutableDictionary dictionary];
    for(NSString *key in keys) {
        BYCLegacyEntry *entry = entries[key];
        [self parseEntry:entry withFormatter:formatter intoDictionary:values];
    }
    
    keys = [values.allKeys sortedArrayWithOptions:0 usingComparator:^NSComparisonResult(NSString* obj1, NSString* obj2) {
        return [[formatter dateFromString:obj1] compare:[formatter dateFromString:obj2]];
    }];
    
    [BYCEntry createDirectories];
    
    for(NSString *key in keys) {
        for(BYCMigrationEntry *migrationEntry in values[key]) {
            BYCEntry *entry = migrationEntry.entry;
            int64_t uid = [self.database saveWithType:entry.type notes:entry.note reasons:entry.reasons createdAt:entry.createdAt];
            NSString *imagePath = [BYCEntry imagePathForEntryId:uid];
            NSString *audioPath = [BYCEntry legacyAudioPathForEntryId:uid];
            NSError *error = nil;
            if(migrationEntry.imagePath.length > 0) {
                UIImage *image = [self scaledImageAtPath:migrationEntry.imagePath];
                if(image) {
                    [manager createFileAtPath:imagePath contents:UIImageJPEGRepresentation(image, 1.0f) attributes:0];
                    [manager removeItemAtPath:migrationEntry.imagePath error:&error];
                }
            }
            if(error) {
                NSLog(@"%@", error); error = nil;
            }
            if(migrationEntry.audioPath.length > 0) {
                [manager moveItemAtPath:migrationEntry.audioPath toPath:audioPath error:&error];
            }
            if(error) {
                NSLog(@"%@", error); error = nil;
            }
        }
    }
    
    for(NSString *path in [BYCMigrationModel allPaths]) {
        [manager removeItemAtPath:path error:nil];
    }
}

-(void)parseEntry:(BYCLegacyEntry*)entry withFormatter:(NSDateFormatter*)formatter intoDictionary:(NSMutableDictionary*)values {
    NSData *data = [entry.value dataUsingEncoding:NSUTF8StringEncoding];
    if(data) {
        NSArray *value = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if([value isKindOfClass:NSArray.class] && value.count == 8) {
            int type = -1;
            NSString *reason, *notes, *dateString, *imageFile, *wavFile;
            NSDate *date;
            checkType(value[0], NSString, type = [self typeFromString:value[0]]);
            checkType(value[1], NSString, reason = value[1]);
            checkType(value[2], NSString, notes = value[2]);
            checkType(value[3], NSString, wavFile = [self cleanPath:value[3]]);
            checkType(value[4], NSString, imageFile = [self cleanPath:value[4]]);
            checkType(value[5], NSString, dateString = value[5]; date = [formatter dateFromString:dateString]);
            
            if(date && type >= 0) {
                NSMutableArray *found = values[dateString];
                if(!found) {
                    found = [NSMutableArray array];
                }
                BYCEntry *entry = [BYCEntry entryWithId:0 type:type note:notes reasons:@[reason] createdAt:date];
                [found addObject:[BYCMigrationEntry entryWithEntry:entry imagePath:imageFile audioPath:wavFile]];
                values[dateString] = found;
            }
        }
    }
}

+(BOOL)needsMigration:(BYCDatabase*)database {
    if(database.isFirstLaunch) {
        NSFileManager *manager = [NSFileManager defaultManager];
        for(NSString *path in [self allPaths]) {
            if([manager fileExistsAtPath:path]) {
                return YES;
            }
        }
    }
    return NO;
}

// path info for PhoneGap localstorage

+(NSArray*)allPaths {
    return @[[self localStoragePath1], [self localStoragePath2], [self localStoragePath3]];
}

// ~/Library/Caches/file__0.localstorage
+(NSString*)localStoragePath1 {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [path stringByAppendingPathComponent:@"Caches/file__0.localstorage"];
}

// ~/Library/WebKit/LocalStorage/file__0.localstorage
+(NSString*)localStoragePath2 {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [path stringByAppendingPathComponent:@"WebKit/LocalStorage/file__0.localstorage"];
}

// ~/Documents/Backups/localstorage.appdata.db
+(NSString*)localStoragePath3 {
    NSString *path = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [path stringByAppendingPathComponent:@"Backups/localstorage.appdata.db"];
}

// conversions/fixes

-(int)typeFromString:(NSString*)string {
    string = [string lowercaseString];
    if([string isEqual:@"angry"]) {
        return BYCMood_Angry;
    } else if([string isEqual:@"confident"]) {
        return BYCMood_Confident;
    } else if([string isEqual:@"confused"]) {
        return BYCMood_Confused;
    } else if([string isEqual:@"depressed"]) {
        return BYCMood_Depressed;
    } else if([string isEqual:@"embarrassed"]) {
        return BYCMood_Embarrassed;
    } else if([string isEqual:@"frustrated"]) {
        return BYCMood_Frustrated;
    } else if([string isEqual:@"happy"]) {
        return BYCMood_Happy;
    } else if([string isEqual:@"invisible"]) {
        return BYCMood_Invisible;
    } else if([string isEqual:@"lonely"]) {
        return BYCMood_Lonely;
    } else if([string isEqual:@"proud"]) {
        return BYCMood_Proud;
    } else if([string isEqual:@"relieved"]) {
        return BYCMood_Relieved;
    } else if([string isEqual:@"stressed"]) {
        return BYCMood_Stressed;
    }
    return -1;
}

-(NSString*)cleanPath:(NSString*)path {
    NSRange range = [path rangeOfString:@"Documents/"];
    if(range.location == NSNotFound) {
        NSString *clean = @"file://localhost";
        return [path stringByReplacingOccurrencesOfString:clean withString:@"" options:NSAnchoredSearch range:NSMakeRange(0, path.length)];
    } else {
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *file = [path substringFromIndex:(range.location+range.length)];
        return [documentsDirectory stringByAppendingPathComponent:file];
    }
}

-(UIImage*)scaledImageAtPath:(NSString*)path {
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    if(image) {
        CGFloat size = 640.0f;
        CGSize newSize = CGSizeMake(size, [image scaledHeightForWidth:size]);
        
        UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
        [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    }
    return nil;
}

@end
