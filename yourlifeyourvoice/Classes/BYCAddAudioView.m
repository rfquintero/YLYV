#import "BYCAddAudioView.h"
#import "BYCUI.h"

#define kRecordRadius 40

typedef enum {
    AudioState_Record,
    AudioState_Recording,
    AudioState_Preview,
} AudioState;

@interface BYCAddAudioView()
@property (nonatomic) UILabel *title;
@property (nonatomic) UIButton *recordButton;
@property (nonatomic) UIButton *playButton;
@property (nonatomic) UIButton *deleteButton;
@property (nonatomic) UIButton *speakerButton;
@property (nonatomic) BOOL playing;
@property (nonatomic) AudioState state;
@property (nonatomic, weak) id<BYCAddAudioViewDelegate> delegate;
@end

@implementation BYCAddAudioView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.title = [BYCUI labelWithRoundFontSize:16.0f];
        
        self.recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.recordButton.layer.borderColor = [UIColor blackColor].CGColor;
        self.recordButton.layer.cornerRadius = kRecordRadius;
        self.recordButton.backgroundColor = [UIColor bgRed];
        self.recordButton.clipsToBounds = YES;
        [self.recordButton addTarget:self action:@selector(startRecording) forControlEvents:UIControlEventTouchDown];
        [self.recordButton addTarget:self action:@selector(stopRecording) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchCancel];
    
        self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.playButton setImage:[UIImage imageNamed:@"icon_button_play"] forState:UIControlStateNormal];
        [self.playButton addTarget:self action:@selector(playRecording) forControlEvents:UIControlEventTouchUpInside];
        
        self.speakerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.speakerButton addTarget:self action:@selector(toggleSpeaker) forControlEvents:UIControlEventTouchUpInside];
    
        self.deleteButton = [BYCUI deleteButtonWithTarget:self action:@selector(deleteSelected)];
        
        [self.scrollView addSubview:self.title];
        [self.scrollView addSubview:self.speakerButton];
        [self.scrollView addSubview:self.recordButton];
        [self.scrollView addSubview:self.playButton];
        [self.scrollView addSubview:self.deleteButton];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self.title centerHorizonallyAtY:20 inBounds:self.bounds thatFits:CGSizeUnbounded];
    [self.speakerButton sizeToFit];
    self.speakerButton.center = CGPointMake(CGRectGetMaxX(self.title.frame)+50, self.title.center.y);
    [self.recordButton centerHorizonallyAtY:CGRectGetMaxY(self.title.frame)+30 inBounds:self.bounds withSize:CGSizeMake(kRecordRadius*2, kRecordRadius*2)];
    [self.playButton centerHorizonallyAtY:CGRectGetMaxY(self.title.frame)+30 inBounds:self.bounds thatFits:CGSizeUnbounded];
    [self.deleteButton centerHorizonallyAtY:200 inBounds:self.bounds thatFits:CGSizeUnbounded];
}

-(void)setHasAudio:(BOOL)hasAudio {
    self.recordButton.hidden = hasAudio;
    self.playButton.hidden = !hasAudio;
    self.deleteButton.hidden = !hasAudio;
    self.speakerButton.hidden = !hasAudio;
    self.state = hasAudio ? AudioState_Preview : AudioState_Record;
}

-(void)setState:(AudioState)state {
    _state = state;
    self.title.attributedText = [self titleForState:state];
    self.recordButton.layer.borderWidth = (state == AudioState_Recording ? 5.0f : 15.0f);
    [self setNeedsLayout];
}

-(void)setPlaying:(BOOL)playing {
    _playing = playing;
    UIImage *image = playing ? [UIImage imageNamed:@"icon_button_stop"] : [UIImage imageNamed:@"icon_button_play"];
    [self.playButton setImage:image forState:UIControlStateNormal];
}

-(void)setSpeakerMode:(BOOL)speakerMode {
    UIImage *image = speakerMode ? [UIImage imageNamed:@"icon_speaker_on"] : [UIImage imageNamed:@"icon_speaker_off"];
    [self.speakerButton setImage:image forState:UIControlStateNormal];
    [self setNeedsLayout];
}

-(NSAttributedString*)titleForState:(AudioState)state {
    switch(state) {
        case AudioState_Record: {
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"Press and HOLD to Record" attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor bgRed] range:NSMakeRange(10, 4)];
            return string;
        }
        case AudioState_Recording: {
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"Recording... RELEASE to stop" attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor bgRed] range:NSMakeRange(13, 7)];
            return string;
        }
        case AudioState_Preview: {
            return [[NSAttributedString alloc] initWithString:@"Preview" attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
        }
    }
}

-(void)toggleSpeaker {
    [self.delegate toggleSpeaker];
}

-(void)startRecording {
    self.state = AudioState_Recording;
    [self.delegate startRecording];
}

-(void)stopRecording {
    if(_state == AudioState_Recording) {
            [self.delegate stopRecording];
    }
    self.state = AudioState_Record;
}

-(void)playRecording {
    if(self.playing) {
        [self.delegate stopPlayback];
    } else {
        self.playing = YES;
        [self.delegate playRecording];
    }
}

-(void)playbackStopped {
    self.playing = NO;
}

-(void)deleteSelected {
    [self.delegate deleteRecording];
}

@end
