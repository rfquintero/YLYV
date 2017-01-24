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
        case BYCMood_Anxious:
            return @"anxious";
        case BYCMood_Bored:
            return @"bored";
        case BYCMood_Disgusted:
            return @"disgusted";
        case BYCMood_Excited:
            return @"excited";
        case BYCMood_Fine:
            return @"fine";
        case BYCMood_Focused:
            return @"focused";
        case BYCMood_Numb:
            return @"numb";
        case BYCMood_Sad:
            return @"sad";
        case BYCMood_Scared:
            return @"scared";
        case BYCMood_Annoyed:
            return @"annoyed";
        case BYCMood_Brave:
            return @"brave";
        case BYCMood_Cautious:
            return @"cautious";
        case BYCMood_Exhausted:
            return @"exhausted";
        case BYCMood_Grateful:
            return @"grateful";
        case BYCMood_Guilty:
            return @"guilty";
        case BYCMood_Inspired:
            return @"inspired";
        case BYCMood_Meh:
            return @"meh";
        case BYCMood_Overwhelmed:
            return @"overwhelmed";
        case BYCMood_Peaceful:
            return @"peaceful";
        case BYCMood_Surprised:
            return @"surprised";
        case BYCMood_Uncomfortable:
            return @"uncomfortable";
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
        case BYCMood_Sad:
        case BYCMood_Scared:
        case BYCMood_Numb:
        case BYCMood_Overwhelmed:
        case BYCMood_Guilty:
        case BYCMood_Uncomfortable:
            return BYCMoodCategory_Negative;
        case BYCMood_Confident:
        case BYCMood_Happy:
        case BYCMood_Proud:
        case BYCMood_Relieved:
        case BYCMood_Excited:
        case BYCMood_Focused:
        case BYCMood_Brave:
        case BYCMood_Grateful:
        case BYCMood_Inspired:
        case BYCMood_Peaceful:
        case BYCMood_Surprised:
            return BYCMoodCategory_Positive;
        case BYCMood_Confused:
        case BYCMood_Embarrassed:
        case BYCMood_Stressed:
        case BYCMood_Disgusted:
        case BYCMood_Anxious:
        case BYCMood_Fine:
        case BYCMood_Bored:
        case BYCMood_Annoyed:
        case BYCMood_Cautious:
        case BYCMood_Meh:
        case BYCMood_Exhausted:
            return BYCMoodCategory_Neutral;
    }
}

+(UIColor*)moodColor:(BYCMoodType)type {
    switch(type) {
        case BYCMood_Confident:
        case BYCMood_Proud:
        case BYCMood_Brave:
        case BYCMood_Surprised:
        case BYCMood_Peaceful:
            return [UIColor bgPurple];
        case BYCMood_Depressed:
        case BYCMood_Lonely:
        case BYCMood_Scared:
        case BYCMood_Sad:
        case BYCMood_Exhausted:
        case BYCMood_Overwhelmed:
            return [UIColor bgBlue];
        case BYCMood_Invisible:
        case BYCMood_Numb:
        case BYCMood_Embarrassed:
        case BYCMood_Disgusted:
        case BYCMood_Guilty:
        case BYCMood_Uncomfortable:
            return [UIColor bgGreen];
        case BYCMood_Happy:
        case BYCMood_Relieved:
        case BYCMood_Excited:
        case BYCMood_Focused:
        case BYCMood_Grateful:
        case BYCMood_Inspired:
            return [UIColor bgYellow];
        case BYCMood_Confused:
        case BYCMood_Stressed:
        case BYCMood_Anxious:
        case BYCMood_Annoyed:
            return [UIColor bgOrange];
        case BYCMood_Angry:
        case BYCMood_Frustrated:
            return [UIColor bgRed];
        case BYCMood_Fine:
        case BYCMood_Bored:
        case BYCMood_Cautious:
        case BYCMood_Meh:
            return [UIColor bgLightOrange];
    }
}

@end
