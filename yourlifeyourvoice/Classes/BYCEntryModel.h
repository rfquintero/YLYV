#import <Foundation/Foundation.h>

#define BYCEntryModelPlaybackError @"BYCEntryModelPlaybackError"
#define BYCEntryModelPlaybackStopped @"BYCEntryModelPlaybackStopped"
#define BYCEntryModelRecordingError @"BYCEntryModelRecordingError"
#define BYCEntryModelRecordingStopped @"BYCEntryModelRecordingStopped"

@interface BYCEntryModel : NSObject
@property (nonatomic) NSString *note;
@property (nonatomic) UIImage *image;
@property (nonatomic, readonly) NSArray *reasons;
@property (nonatomic, readonly) BOOL hasRecording;
@property (nonatomic, readonly) BOOL speakerMode;
@property (nonatomic, readonly) NSTimeInterval recordingDuration;

-(void)addReason:(NSString*)reason;
-(void)removeReason:(NSString*)reason;

-(void)prepareRecording;
-(BOOL)startRecording;
-(void)stopRecording;
-(void)deleteRecording;

-(void)preparePlayer;
-(BOOL)playRecording;
-(void)stopPlayback;
-(void)useSpeaker:(BOOL)speaker;
@end
