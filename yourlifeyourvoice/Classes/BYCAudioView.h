#import <UIKit/UIKit.h>

@protocol BYCAudioViewDelegate <NSObject>
-(void)playRecording;
-(void)stopPlayback;
-(void)toggleSpeaker;
-(void)editSelected;
@end

@interface BYCAudioView : UIView
-(void)setSpeakerMode:(BOOL)speakerMode;
-(void)setDuration:(NSTimeInterval)duration;
-(void)playbackStopped;
-(void)setDelegate:(id<BYCAudioViewDelegate>)delegate;
@end
