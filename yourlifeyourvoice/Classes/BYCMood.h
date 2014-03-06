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
} BYCMoodType;

@interface BYCMood : NSObject

+(NSString*)moodString:(BYCMoodType)type;
+(UIColor*)moodColor:(BYCMoodType)type;
+(UIImage*)moodImage:(BYCMoodType)type;
+(UIImage*)spriteImage:(BYCMoodType)type;
+(NSDictionary*)plist:(BYCMoodType)type;
+(UIImage*)smallSpriteImage:(BYCMoodType)type;
+(NSDictionary*)smallPlist:(BYCMoodType)type;
+(NSDictionary*)animationList:(BYCMoodType)type;
@end
