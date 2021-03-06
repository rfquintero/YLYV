#import <Foundation/Foundation.h>

typedef enum {
    BYCMood_Angry,
    BYCMood_Confident,
    BYCMood_Confused,
    BYCMood_Depressed,
    BYCMood_Embarrassed,
    BYCMood_Frustrated,
    BYCMood_Happy,
    BYCMood_Invisible,
    BYCMood_Lonely,
    BYCMood_Proud,
    BYCMood_Relieved,
    BYCMood_Stressed,
    BYCMood_Anxious,
    BYCMood_Bored,
    BYCMood_Disgusted,
    BYCMood_Excited,
    BYCMood_Fine,
    BYCMood_Focused,
    BYCMood_Numb,
    BYCMood_Sad,
    BYCMood_Scared,
    BYCMood_Annoyed,
    BYCMood_Brave,
    BYCMood_Cautious,
    BYCMood_Exhausted,
    BYCMood_Grateful,
    BYCMood_Guilty,
    BYCMood_Inspired,
    BYCMood_Meh,
    BYCMood_Overwhelmed,
    BYCMood_Peaceful,
    BYCMood_Surprised,
    BYCMood_Uncomfortable,
} BYCMoodType;

typedef enum {
    BYCMoodCategory_Neutral,
    BYCMoodCategory_Positive,
    BYCMoodCategory_Negative,
} BYCMoodCategory;

@interface BYCMood : NSObject

+(NSString*)moodString:(BYCMoodType)type;
+(UIColor*)moodColor:(BYCMoodType)type;
+(UIImage*)moodImageStart:(BYCMoodType)type;
+(UIImage*)moodImageEnd:(BYCMoodType)type;
+(UIImage*)spriteImage:(BYCMoodType)type;
+(NSDictionary*)plist:(BYCMoodType)type;
+(UIImage*)smallSpriteImage:(BYCMoodType)type;
+(NSDictionary*)smallPlist:(BYCMoodType)type;
+(NSDictionary*)animationList:(BYCMoodType)type;
+(NSString*)responseForCategory:(BYCMoodCategory)category;
+(BYCMoodCategory)categoryForMood:(BYCMoodType)type;
@end
