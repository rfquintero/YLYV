#import "BYCMood.h"
#import "BYCUI.h"

@implementation BYCMood

+(NSString*)moodString:(BYCMoodType)type {
    switch(type) {
        case BYCMood_Angry:
            return @"angry";
        case BYCMood_Confident:
            return @"confident";
        case BYCMood_Confused:
            return @"confused";
        case BYCMood_Depressed:
            return @"depressed";
        case BYCMood_Embarrassed:
            return @"embarrassed";
        case BYCMood_Frustrated:
            return @"frustrated";
        case BYCMood_Happy:
            return @"happy";
        case BYCMood_Invisible:
            return @"invisible";
        case BYCMood_Lonely:
            return @"lonely";
        case BYCMood_Proud:
            return @"proud";
        case BYCMood_Relieved:
            return @"relieved";
        case BYCMood_Stressed:
            return @"stressed";
    }
}

+(UIImage*)moodImageStart:(BYCMoodType)type {
    NSString *mood = [[self moodString:type] lowercaseString];
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"face_%@_start", mood] ofType:@"png"];
    return [UIImage imageWithContentsOfFile:path];
}

+(UIImage*)moodImageEnd:(BYCMoodType)type {
    NSString *mood = [[self moodString:type] lowercaseString];
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"face_%@_end", mood] ofType:@"png"];
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
    return [self spriteImage:type];
}

+(NSDictionary*)smallPlist:(BYCMoodType)type {
    return [self plist:type];
}

+(NSDictionary*)animationList:(BYCMoodType)type {
    NSString *mood = [[self moodString:type] lowercaseString];
    NSString* path = [[NSBundle mainBundle] pathForResource:@"animations" ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:path][mood];
}

+(NSString*)responseForCategory:(BYCMoodCategory)category {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"responses" ofType:@"plist"];
    NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSString *key;
    switch(category) {
        case BYCMoodCategory_Neutral:
            key = @"neutral";
            break;
        case BYCMoodCategory_Negative:
            key = @"negative";
            break;
        case BYCMoodCategory_Positive:
            key = @"positive";
            break;
    }
    
    NSArray *responses = plist[key];
    return responses[random()%responses.count];
}

+(BYCMoodCategory)categoryForMood:(BYCMoodType)type {
    switch (type) {
        case BYCMood_Angry:
        case BYCMood_Depressed:
        case BYCMood_Frustrated:
        case BYCMood_Invisible:
        case BYCMood_Lonely:
            return BYCMoodCategory_Negative;
        case BYCMood_Confident:
        case BYCMood_Happy:
        case BYCMood_Proud:
        case BYCMood_Relieved:
            return BYCMoodCategory_Positive;
        case BYCMood_Confused:
        case BYCMood_Embarrassed:
        case BYCMood_Stressed:
            return BYCMoodCategory_Neutral;
    }
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
        case BYCMood_Embarrassed:
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
