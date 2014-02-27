#import "BYCMood.h"

@implementation BYCMood

+(NSString*)moodString:(BYCMoodType)type {
    switch(type) {
        case BYCMood_Angry:
            return @"Angry";
        case BYCMood_Confident:
            return @"Confident";
        case BYCMood_Confused:
            return @"Confused";
        case BYCMood_Depressed:
            return @"Depressed";
        case BYCMood_Embarassed:
            return @"Embarassed";
        case BYCMood_Frustrated:
            return @"Frustrated";
        case BYCMood_Happy:
            return @"Happy";
        case BYCMood_Invisible:
            return @"Invisible";
        case BYCMood_Lonely:
            return @"Lonely";
        case BYCMood_Proud:
            return @"Proud";
        case BYCMood_Relieved:
            return @"Relieved";
        case BYCMood_Stressed:
            return @"Stressed";
    }
}

+(UIImage*)spriteImage:(BYCMoodType)type {
    NSString *mood = [[self moodString:type] lowercaseString];
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@.1", mood] ofType:@"png"];
    return [UIImage imageWithContentsOfFile:path];
}

+(NSDictionary*)plist:(BYCMoodType)type {
    NSString *mood = [[self moodString:type] lowercaseString];
    NSString* path = [[NSBundle mainBundle] pathForResource:mood ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:path];
}

@end
