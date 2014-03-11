#import "BYCEntrySavedView.h"
#import "BYCUI.h"
#import "BYCConstants.h"

@interface BYCEntrySavedView()
@property (nonatomic) UILabel *titleText;
@property (nonatomic) UILabel *blurbText;
@property (nonatomic) UIButton *reminderButton;
@property (nonatomic) UIButton *talkButton;
@property (nonatomic) UIButton *moodsButton;
@property (nonatomic) UIButton *infoButton;
@property (nonatomic) UIButton *tipsButton;
@property (nonatomic) UIButton *callButton;
@property (nonatomic) UIButton *cancelButton;
@property (nonatomic, weak) id<BYCEntrySavedViewDelegate> delegate;
@end

@implementation BYCEntrySavedView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleText = [BYCUI labelWithRoundFontSize:20.0f];
        
        self.blurbText = [BYCUI labelWithRoundFontSize:14.0f];
        
        self.reminderButton = [BYCUI standardButtonWithTitle:@"SET A REMINDER" target:self action:@selector(reminderSelected)];
        self.moodsButton = [BYCUI standardButtonWithTitle:@"MY MOODS" target:self action:@selector(moodsSelected)];
        self.talkButton = [BYCUI standardButtonWithTitle:@"4 WAYS TO GET HELP" target:self action:@selector(talkSelected)];
        self.tipsButton = [BYCUI standardButtonWithTitle:@"TIPS" target:self action:@selector(tipsSelected)];
        self.infoButton = [BYCUI standardButtonWithTitle:@"YOUR LIFE YOUR VOICE" target:self action:@selector(infoSelected)];
        self.callButton = [BYCUI standardButtonWithTitle:[NSString stringWithFormat:@"CALL %@", BYCPhoneNumber] target:self action:@selector(callSelected)];

        self.cancelButton = [BYCUI deleteButtonWithTarget:self action:@selector(cancelSelected)];
        [self.cancelButton setTitle:@"no, thank you." forState:UIControlStateNormal];
        
        [self addSubview:self.titleText];
        [self addSubview:self.blurbText];
        [self addSubview:self.tipsButton];
        [self addSubview:self.callButton];
        [self addSubview:self.reminderButton];
        [self addSubview:self.talkButton];
        [self addSubview:self.moodsButton];
        [self addSubview:self.infoButton];
        [self addSubview:self.cancelButton];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat padding = 10.0f;
    CGFloat paddedWidth = self.bounds.size.width-2*padding;
    CGFloat textButtonHeight = 25.0f;
    
    [self.titleText centerHorizonallyAtY:0 inBounds:self.bounds thatFits:CGSizeUnbounded];
    [self.blurbText centerHorizonallyAtY:CGRectGetMaxY(self.titleText.frame)+10.0f inBounds:self.bounds thatFits:CGSizeMake(paddedWidth, CGFLOAT_MAX)];

    CGFloat buttonHeight = [self.reminderButton sizeThatFits:CGSizeUnbounded].height;
    self.reminderButton.frame = CGRectMake(padding, CGRectGetMaxY(self.blurbText.frame)+10.0f, paddedWidth, buttonHeight);
    
    CGFloat moodsOffset = self.reminderButton.hidden ? self.reminderButton.frame.origin.y : CGRectGetMaxY(self.reminderButton.frame)+padding;
    self.moodsButton.frame = CGRectMake(padding, moodsOffset, paddedWidth, buttonHeight);
    self.infoButton.frame = CGRectMake(padding, CGRectGetMaxY(self.moodsButton.frame)+padding, paddedWidth, buttonHeight);
    
    self.callButton.frame = self.reminderButton.frame;
    self.talkButton.frame = CGRectMake(padding, CGRectGetMaxY(self.callButton.frame)+padding, paddedWidth, buttonHeight);
    
    CGFloat tipsOffsetY = self.cancelButton.hidden ? CGRectGetMaxY(self.moodsButton.frame)+padding : CGRectGetMaxY(self.talkButton.frame)+padding;
    self.tipsButton.frame = CGRectMake(padding, tipsOffsetY, paddedWidth, buttonHeight);
    
    self.cancelButton.frame = CGRectMake(padding, CGRectGetMaxY(self.tipsButton.frame)+padding, paddedWidth, textButtonHeight);
}

-(void)setMoodCategory:(BYCMoodCategory)category title:(NSString *)title moodString:(NSString *)moodString hideReminders:(BOOL)hideReminders {
    switch(category) {
        case BYCMoodCategory_Negative:
            [self setNegativeTitle:title moodString:moodString];
            break;
        case BYCMoodCategory_Neutral:
            [self setNeutralTitle:title moodString:moodString hideReminders:hideReminders];
            break;
        case BYCMoodCategory_Positive:
            [self setPositiveTitle:title hideReminders:hideReminders];
            break;
    }
    [self setNeedsLayout];
}

-(void)setPositiveTitle:(NSString*)title hideReminders:(BOOL)hideReminders {
    self.titleText.text = title;
    self.blurbText.text = @"What's next?";
    self.reminderButton.hidden = hideReminders;
    self.moodsButton.hidden = NO;
    self.infoButton.hidden = NO;
    
    self.tipsButton.hidden = YES;
    self.callButton.hidden = YES;
    self.talkButton.hidden = YES;
    self.cancelButton.hidden = YES;
}

-(void)setNeutralTitle:(NSString*)title moodString:(NSString*)moodString hideReminders:(BOOL)hideReminders {
    self.titleText.text = title;
    self.blurbText.text = @"What's next?";
    [self.tipsButton setTitle:[NSString stringWithFormat:@"%@ TIPS", [moodString uppercaseString]] forState:UIControlStateNormal];
    self.reminderButton.hidden = hideReminders;
    self.moodsButton.hidden = NO;
    self.tipsButton.hidden = NO;
    
    self.infoButton.hidden = YES;
    self.callButton.hidden = YES;
    self.talkButton.hidden = YES;
    self.cancelButton.hidden = YES;
}

-(void)setNegativeTitle:(NSString*)title moodString:(NSString*)moodString {
    self.titleText.text = title;
    self.blurbText.text = @"We're here if you want to talk about it.";
    [self.tipsButton setTitle:[NSString stringWithFormat:@"%@ TIPS", [moodString uppercaseString]] forState:UIControlStateNormal];
    self.tipsButton.hidden = NO;
    self.callButton.hidden = NO;
    self.talkButton.hidden = NO;
    self.cancelButton.hidden = NO;
    
    self.moodsButton.hidden = YES;
    self.infoButton.hidden = YES;
    self.reminderButton.hidden = YES;
}

#pragma mark callbacks

-(void)reminderSelected {
    [self.delegate reminderSelected];
}

-(void)talkSelected {
    [self.delegate talkSelected];
}

-(void)moodsSelected {
    [self.delegate moodsSelected];
}

-(void)infoSelected {
    [self.delegate infoSelected];
}

-(void)cancelSelected {
    [self.delegate cancelSelected];
}

-(void)callSelected {
    [self.delegate callSelected];
}

-(void)tipsSelected {
    [self.delegate tipsSelected];
}

@end
