#import <UIKit/UIKit.h>

@protocol BYCAddEntryViewDelegate <NSObject>
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
-(void)setMoodText:(NSString*)text;
-(void)setImage:(UIImage*)image;
-(void)setReasons:(NSArray*)reasons;
-(void)resetContent;
-(void)setSpeakerMode:(BOOL)speakerMode;
-(void)setAudioDuration:(NSTimeInterval)duration;
-(void)playbackStopped;
-(void)setDelegate:(id<BYCAddEntryViewDelegate>)delegate;
@end
