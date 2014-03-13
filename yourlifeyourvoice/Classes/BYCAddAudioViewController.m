#import "BYCAddAudioViewController.h"
#import "BYCAddAudioView.h"

@interface BYCAddAudioViewController ()<BYCAddAudioViewDelegate, UIAlertViewDelegate>
@property (nonatomic) BYCEntryModel *model;
@property (nonatomic) BYCAddAudioView *entryView;
@end

@implementation BYCAddAudioViewController

-(id)initWithApplicationState:(BYCApplicationState *)applicationState model:(BYCEntryModel*)model {
    if(self = [super initWithApplicationState:applicationState]) {
        self.model = model;
    }
    return self;
}

-(void)loadView {
    [super loadView];
    
    self.entryView = [[BYCAddAudioView alloc] initWithFrame:self.view.bounds];
    self.entryView.delegate = self;
    [self.entryView setHasAudio:self.model.hasRecording];

    [self.navView setContentView:self.entryView];
    [self.navView setNavTitle:@"Add Audio"];
    [self setupBackButton];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(self.model.hasRecording) {
        [self.model preparePlayer];
    } else {
        [self.model prepareRecording];
    }
    [self.entryView setSpeakerMode:self.model.speakerMode];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackError) name:BYCEntryModelPlaybackError object:self.model];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackStopped) name:BYCEntryModelPlaybackStopped object:self.model];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recordingError) name:BYCEntryModelRecordingError object:self.model];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recordingStopped) name:BYCEntryModelRecordingStopped object:self.model];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)startRecording {
    if(![self.model startRecording]) {
        [self recordingError];
    }
}

-(void)stopRecording {
    [self.model stopRecording];
    [self.model preparePlayer];
    [self.entryView setSpeakerMode:self.model.speakerMode];
}

-(void)playRecording {
    if(![self.model playRecording]) {
        [self playbackError];
    }
}

-(void)stopPlayback {
    [self.model stopPlayback];
    [self playbackStopped];
}

-(void)deleteRecording {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete recording?" message:@"Are you sure you want to delete this recording?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes, delete", nil];
    [alert show];
}

-(void)toggleSpeaker {
    [self.model useSpeaker:!self.model.speakerMode];
    [self.entryView setSpeakerMode:self.model.speakerMode];
}

#pragma mark callbacks

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(buttonIndex != alertView.cancelButtonIndex) {
        [self.model deleteRecording];
        [self.entryView setHasAudio:self.model.hasRecording];
        [self.model prepareRecording];
    }
}

-(void)playbackError {
    [self showError:@"Audio Error" message:@"An error occurred during playback."];
    [self playbackStopped];
}

-(void)playbackStopped {
    [self.entryView playbackStopped];
}

-(void)recordingError {
    [self.model deleteRecording];
    [self showError:@"Audio Error" message:@"An error occurred during recording."];
    [self.entryView setHasAudio:NO];
}

-(void)recordingStopped {
    [self.entryView setHasAudio:self.model.hasRecording];
}

@end
