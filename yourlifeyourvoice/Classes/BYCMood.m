#import "BYCMood.h"
#import "BYCUI.h"

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

+(UIImage*)moodImage:(BYCMoodType)type {
    NSString *mood = [[self moodString:type] lowercaseString];
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"face_%@", mood] ofType:@"png"];
    return [UIImage imageWithContentsOfFile:path];
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

+(UIImage*)smallSpriteImage:(BYCMoodType)type {
    NSString *mood = [[self moodString:type] lowercaseString];
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_small.1", mood] ofType:@"png"];
    return [UIImage imageWithContentsOfFile:path];
}

+(NSDictionary*)smallPlist:(BYCMoodType)type {
    NSString *mood = [[self moodString:type] lowercaseString];
    NSString* path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_small", mood] ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:path];
}

+(NSDictionary*)animationList:(BYCMoodType)type {
    NSString *mood = [[self moodString:type] lowercaseString];
    NSString* path = [[NSBundle mainBundle] pathForResource:@"animations" ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:path][mood];
}

+(UIColor*)moodColor:(BYCMoodType)type {
    switch(type) {
        case BYCMood_Confident:
        case BYCMood_Proud:
            return [UIColor bgPurple];
        case BYCMood_Depressed:
        case BYCMood_Lonely:
            return [UIColor bgBlue];
        case BYCMood_Invisible:
        case BYCMood_Embarassed:
            return [UIColor bgGreen];
        case BYCMood_Happy:
        case BYCMood_Relieved:
            return [UIColor bgYellow];
        case BYCMood_Confused:
        case BYCMood_Stressed:
            return [UIColor bgOrange];
        case BYCMood_Angry:
        case BYCMood_Frustrated:
            return [UIColor bgRed];
    }
}

@end
