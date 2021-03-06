#import "BYCEntryModel.h"
#import <AVFoundation/AVFoundation.h>

@interface BYCEntryModel()<AVAudioRecorderDelegate, AVAudioPlayerDelegate>
@property (nonatomic) BYCDatabase *database;
@property (nonatomic) BYCQueue *queue;

@property (nonatomic) BYCEntry *entry;
@property (nonatomic, readwrite) BYCEntry *updatedEntry;
@property (nonatomic) NSMutableArray *reasonsM;
@property (nonatomic) AVAudioRecorder *recorder;
@property (nonatomic) AVAudioPlayer *player;

@property (nonatomic) NSString *imagePath;

@property (nonatomic) NSURL *audioUrl;
@end

@implementation BYCEntryModel

-(id)initWithDatabase:(BYCDatabase*)database queue:(BYCQueue*)queue {
    if(self = [super init]) {
        self.database = database;
        self.queue = queue;
        self.reasonsM = [NSMutableArray array];
    }
    return self;
}

-(void)setEntry:(BYCEntry *)entry {
    entry = [self.database getEntryWithUid:entry.uid];
    _entry = entry;
    self.type = entry.type;
    self.note = entry.note;
    [self.reasonsM addObjectsFromArray:entry.reasons];
    
    self.image = entry.image;
    self.imagePath = entry.imagePath;

    if(entry.audioFile) {
        self.audioUrl = entry.audioFile;
        [self preparePlayer];
    }
}

-(void)saveMediaForUid:(int64_t)uid {
    NSFileManager *manager = [NSFileManager defaultManager];
    if(self.image) {
        NSString *imagePath = [BYCEntry imagePathForEntryId:uid];
        if(![manager fileExistsAtPath:imagePath]) {
            [manager createFileAtPath:imagePath contents:UIImageJPEGRepresentation(self.image, 1.0f) attributes:0];
        }
    }
    if(self.hasRecording && !self.entry.legacyAudio) {
        NSString *audioPath = [BYCEntry audioPathForEntryId:uid];
        if(![manager fileExistsAtPath:audioPath]) {
            [manager moveItemAtPath:self.audioUrl.path toPath:audioPath error:nil];
        }
    }
}

-(void)save {
    [self.queue performAsync:^{
        int64_t uid = [self.database saveWithType:self.type notes:(self.note ? self.note : @"") reasons:self.reasons];
        [self saveMediaForUid:uid];
    } callback:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:BYCEntryModelSaveSuccessful object:self];
    } blocking:NO];
}

-(void)update {
    [self.queue performAsync:^{
        [self.database updateEntry:self.entry notes:self.note reasons:self.reasons];
        [self saveMediaForUid:_entry.uid];
    } callback:^{
        self.updatedEntry = [BYCEntry entryWithId:self.entry.uid type:self.entry.type note:self.note reasons:self.reasons createdAt:self.entry.createdAt];
        [[NSNotificationCenter defaultCenter] postNotificationName:BYCEntryModelSaveSuccessful object:self];
    } blocking:NO];
}

-(void)deleteEntry {
    [self deleteImage];
    [self deleteRecording];
    [self.database deleteEntry:self.entry];
}

-(void)reset {
    [self deleteRecording];
    self.type = 0;
    self.recorder = nil;
    self.audioUrl = nil;
    self.image = nil;
    [self.reasonsM removeAllObjects];
}

-(void)deleteImage {
    if(self.imagePath) {
        [[NSFileManager defaultManager] removeItemAtPath:self.imagePath error:nil];
    }
    self.imagePath = nil;
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
    }
    if(!self.recorder) {
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
    self.recorder = nil;
    self.audioUrl = nil;
    self.entry.legacyAudio = NO;
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

-(BOOL)speakerMode {
    for(AVAudioSessionPortDescription *port in [[[AVAudioSession sharedInstance] currentRoute] outputs]) {
        if([port.portType isEqual:AVAudioSessionPortBuiltInSpeaker])
            return YES;
    }
    return NO;
}

-(void)useSpeaker:(BOOL)speaker {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if(speaker) {
        [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    } else {
        [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
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
