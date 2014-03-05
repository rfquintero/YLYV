#import "BYCContentView.h"
#import "BYCMood.h"
#import "BYCEntrySavedView.h"

@protocol BYCEntryViewDelegate <BYCEntrySavedViewDelegate>
-(void)entryStarted;
-(void)photoSelected;
-(void)becauseSelected;
-(void)audioSelected;
-(void)saveSelected;
-(void)deleteSelected;
-(void)playRecording;
-(void)stopPlayback;
-(void)toggleSpeaker;
-(void)typeSelected:(BYCMoodType)type;
-(void)noteChanged:(NSString*)note;
-(void)setNavActive:(BOOL)active;
@end

@interface BYCEntryView : BYCContentView
-(void)discardEntry;
-(void)setNavView:(UIView*)navView;
-(void)setImage:(UIImage*)image;
-(void)setReasons:(NSArray*)reasons;
-(void)setSpeakerMode:(BOOL)speakerMode;
-(void)setAudioDuration:(NSTimeInterval)duration;
-(void)playbackStopped;
-(void)setSavedStandardTitle:(NSString*)title hideReminders:(BOOL)hideReminders;
-(void)setSavedAlternateTitle:(NSString*)title;
-(void)setDelegate:(id<BYCEntryViewDelegate>)delegate;
@end
