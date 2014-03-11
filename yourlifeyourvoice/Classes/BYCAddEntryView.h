#import <UIKit/UIKit.h>
#import "BYCMood.h"
#import "BYCEntrySavedView.h"

@protocol BYCAddEntryViewDelegate <BYCEntrySavedViewDelegate>
-(void)photoSelected;
-(void)becauseSelected;
-(void)audioSelected;
-(void)saveSelected;
-(void)deleteSelected;
-(void)playRecording;
-(void)stopPlayback;
-(void)toggleSpeaker;
-(void)noteChanged:(NSString*)string;
-(void)offsetChanged:(CGFloat)percent;
-(void)setNavActive:(BOOL)active;
@end

@interface BYCAddEntryView : UIView
@property (nonatomic) CGFloat contentOffset;
-(void)setMood:(BYCMoodType)type;
-(void)setNote:(NSString*)note;
-(void)setImage:(UIImage*)image;
-(void)setReasons:(NSArray*)reasons;
-(void)resetContent;
-(void)setSpeakerMode:(BOOL)speakerMode;
-(void)setAudioDuration:(NSTimeInterval)duration;
-(void)playbackStopped;
-(void)setMoodCategory:(BYCMoodCategory)category title:(NSString*)title moodString:(NSString*)moodString hideReminders:(BOOL)hideReminders;
-(void)setDelegate:(id<BYCAddEntryViewDelegate>)delegate;
@end
