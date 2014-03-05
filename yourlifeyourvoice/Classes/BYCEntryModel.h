#import <Foundation/Foundation.h>
#import "BYCDatabase.h"
#import "BYCQueue.h"

#define BYCEntryModelSaveSuccessful @"BYCEntryModelSaveSuccessful"
#define BYCEntryModelPlaybackError @"BYCEntryModelPlaybackError"
#define BYCEntryModelPlaybackStopped @"BYCEntryModelPlaybackStopped"
#define BYCEntryModelRecordingError @"BYCEntryModelRecordingError"
#define BYCEntryModelRecordingStopped @"BYCEntryModelRecordingStopped"

@interface BYCEntryModel : NSObject
@property (nonatomic) BYCMoodType type;
@property (nonatomic) NSString *note;
@property (nonatomic) UIImage *image;
@property (nonatomic, readonly) NSArray *reasons;
@property (nonatomic, readonly) BOOL hasRecording;
@property (nonatomic, readonly) BOOL speakerMode;
@property (nonatomic, readonly) NSTimeInterval recordingDuration;

-(id)initWithDatabase:(BYCDatabase*)database queue:(BYCQueue*)queue;

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

-(void)reset;
-(void)save;
@end
