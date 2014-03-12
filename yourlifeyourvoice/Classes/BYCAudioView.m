#import "BYCAudioView.h"
#import "BYCUI.h"

@interface BYCAudioView()
@property (nonatomic) UIButton *editButton;
@property (nonatomic) UIButton *playButton;
@property (nonatomic) UIButton *speakerButton;
@property (nonatomic) UILabel *durationLabel;
@property (nonatomic) BOOL playing;
@property (nonatomic, readwrite) BOOL hasContent;
@property (nonatomic, weak) id<BYCAudioViewDelegate> delegate;
@end

@implementation BYCAudioView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"edit" attributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle), NSFontAttributeName : [UIFont systemFontOfSize:14.0f]}];
        self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.editButton setAttributedTitle:title forState:UIControlStateNormal];
        [self.editButton setContentEdgeInsets:UIEdgeInsetsMake(12, 8, 12, 0)];
        [self.editButton addTarget:self action:@selector(editSelected) forControlEvents:UIControlEventTouchUpInside];
        
        self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.playButton setImage:[UIImage imageNamed:@"icon_button_play"] forState:UIControlStateNormal];
        [self.playButton addTarget:self action:@selector(playRecording) forControlEvents:UIControlEventTouchUpInside];
        
        self.speakerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.speakerButton addTarget:self action:@selector(toggleSpeaker) forControlEvents:UIControlEventTouchUpInside];
        [self.speakerButton setContentEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        
        self.durationLabel = [BYCUI labelWithFont:[UIFont systemFontOfSize:14.0f]];
        self.durationLabel.textColor = [UIColor blackColor];
        
        [self addSubview:self.editButton];
        [self addSubview:self.playButton];
        [self addSubview:self.speakerButton];
        [self addSubview:self.durationLabel];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat padding = 10.0f;
    CGFloat width = self.bounds.size.width;
    [self.playButton centerVerticallyAtX:padding inBounds:self.bounds thatFits:CGSizeUnbounded];
    
    CGSize editSize = [self.editButton sizeThatFits:CGSizeUnbounded];
    [self.editButton centerVerticallyAtX:width-padding-editSize.width inBounds:self.bounds withSize:editSize];

    CGFloat offsetX = CGRectGetMaxX(self.playButton.frame) + 20;
    [self.durationLabel setFrameAtOriginThatFitsUnbounded:CGPointMake(offsetX, self.playButton.center.y+5)];
    CGSize speakerSize = [self.speakerButton sizeThatFits:CGSizeUnbounded];
    self.speakerButton.frame = CGRectMake(offsetX-5, self.playButton.center.y-speakerSize.height+4, speakerSize.width, speakerSize.height);
}

-(CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(size.width, [self.playButton sizeThatFits:CGSizeUnbounded].height + 20);
}

-(void)setDuration:(NSTimeInterval)duration {
    _hasContent = duration > 0;
    int sec = (int)duration % 60;
    int min = (int)(duration/60)%60;
    int hour = (int)(duration/3600);
    if(hour) {
        self.durationLabel.text = [NSString stringWithFormat:@"%d:%d:%02d", hour, min, sec];
    } else {
        self.durationLabel.text = [NSString stringWithFormat:@"%d:%02d", min, sec];
    }
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

-(void)toggleSpeaker {
    [self.delegate toggleSpeaker];
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

-(void)editSelected {
    [self.delegate editSelected];
}

@end
