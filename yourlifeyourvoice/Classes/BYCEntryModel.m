#import "BYCEntryModel.h"
#import <AVFoundation/AVFoundation.h>

@interface BYCEntryModel()<AVAudioRecorderDelegate, AVAudioPlayerDelegate>
@property (nonatomic) NSMutableArray *reasonsM;
@property (nonatomic) AVAudioRecorder *recorder;
@property (nonatomic) AVAudioPlayer *player;

@property (nonatomic) NSURL *audioUrl;
@property (nonatomic, readwrite) BOOL speakerMode;
@end

@implementation BYCEntryModel

-(id)init {
    if(self = [super init]) {
        self.reasonsM = [NSMutableArray array];
    }
    return self;
}

-(void)addReason:(NSString *)reason {
    if(![self.reasonsM containsObject:reason]) {
        [self.reasonsM addObject:reason];
    }
}

-(void)removeReason:(NSString*)reason {
    [self.reasonsM removeObject:reason];
}

-(NSArray*)reasons {
    return self.reasonsM;
}

-(NSURL*)tempAudioFile {
    NSString *tempPath = NSTemporaryDirectory();
    NSString *tempFile = [tempPath stringByAppendingPathComponent:[NSString stringWithFormat:@"tmp-%i.ima4", (int)[NSDate date].timeIntervalSince1970]];
    return [NSURL fileURLWithPath:tempFile];
}

-(BOOL)hasRecording {
    return self.audioUrl && [[NSFileManager defaultManager] fileExistsAtPath:self.audioUrl.path];
}

-(NSTimeInterval)recordingDuration {
    if(self.hasRecording && self.player) {
        return self.player.duration;
    } else {
        return -1;
    }
}

-(void)prepareAudio {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
}

-(void)prepareRecording {
    if(!self.audioUrl) {
        self.audioUrl = self.tempAudioFile;
        
        NSDictionary *settings = @{ AVFormatIDKey : @(kAudioFormatAppleIMA4),
                                    AVSampleRateKey : @(16000.0),
                                    AVNumberOfChannelsKey : @(1)};
        
        self.recorder = [[AVAudioRecorder alloc] initWithURL:self.audioUrl settings:settings error:nil];
        self.recorder.delegate = self;
    }
    [self prepareAudio];
    [self.recorder prepareToRecord];
}

-(BOOL)startRecording {
    return [self.recorder record];
}

-(void)stopRecording {
    [self.recorder stop];
}

-(void)deleteRecording {
    [[NSFileManager defaultManager] removeItemAtURL:self.audioUrl error:nil];
    self.player = nil;
}

-(void)preparePlayer {
    if(self.hasRecording) {
        [self prepareAudio];
        
        if(!self.player) {
            self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.audioUrl error:nil];
            self.player.delegate = self;
        }
        
        [self.player prepareToPlay];
    }
}

-(BOOL)playRecording {
    return [self.player play];
}

-(void)stopPlayback {
    [self.player stop];
    self.player.currentTime = 0;
}

-(void)useSpeaker:(BOOL)speaker {
    _speakerMode = speaker;
    if(speaker) {
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
    } else {
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_None;
        AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
    }
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    [self postOnMain:BYCEntryModelRecordingStopped];
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error {
    [self postOnMain:BYCEntryModelRecordingError];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self postOnMain:BYCEntryModelPlaybackStopped];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    [self postOnMain:BYCEntryModelPlaybackError];
}

-(void)postOnMain:(NSString*)notificationName {
    [self performSelectorOnMainThread:@selector(post:) withObject:notificationName waitUntilDone:NO];
}

-(void)post:(NSString*)notificationName {
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self];
}

@end
