#import "BYCContentView.h"

@protocol BYCAddAudioViewDelegate <NSObject>
-(void)startRecording;
-(void)stopRecording;
-(void)playRecording;
-(void)stopPlayback;
-(void)deleteRecording;
-(void)toggleSpeaker;
@end

@interface BYCAddAudioView : BYCContentView
-(void)setHasAudio:(BOOL)hasAudio;
-(void)setSpeakerMode:(BOOL)speakerMode;
-(void)playbackStopped;
-(void)setDelegate:(id<BYCAddAudioViewDelegate>)delegate;
@end