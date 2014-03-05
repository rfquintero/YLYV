#import "BYCEntrySavedView.h"
#import "BYCUI.h"

@interface BYCEntrySavedView()
@property (nonatomic) UILabel *titleText;
@property (nonatomic) UILabel *largeText;
@property (nonatomic) UILabel *smallText;
@property (nonatomic) UIButton *reminderButton;
@property (nonatomic) UIButton *talkButton;
@property (nonatomic) UIButton *moodsButton;
@property (nonatomic) UIButton *infoButton;
@property (nonatomic) UIButton *cancelButton;
@property (nonatomic, weak) id<BYCEntrySavedViewDelegate> delegate;
@end

@implementation BYCEntrySavedView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleText = [BYCUI labelWithRoundFontSize:20.0f];
        
        self.largeText = [BYCUI labelWithRoundFontSize:14.0f];
        self.largeText.text = @"What's next?";
        
        self.smallText = [BYCUI labelWithFont:[UIFont systemFontOfSize:13.0f]];
        self.smallText.text = @"Hey, it looks like things haven't been going so good. We're here if you want to talk about it.";
        self.smallText.numberOfLines = 0;
        
        self.reminderButton = [BYCUI standardButtonWithTitle:@"SET A REMINDER" target:self action:@selector(reminderSelected)];
        self.talkButton = [BYCUI standardButtonWithTitle:@"TALK TO SOMEONE" target:self action:@selector(talkSelected)];
        self.moodsButton = [BYCUI standardButtonWithTitle:@"MY MOODS" target:self action:@selector(moodsSelected)];

        self.infoButton = [BYCUI deleteButtonWithTarget:self action:@selector(infoSelected)];
        [self.infoButton setTitle:@"maybe? tell more more" forState:UIControlStateNormal];
        [self.infoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.infoButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        
        self.cancelButton = [BYCUI deleteButtonWithTarget:self action:@selector(cancelSelected)];
        [self.cancelButton setTitle:@"no, thank you." forState:UIControlStateNormal];
        
        [self addSubview:self.titleText];
        [self addSubview:self.largeText];
        [self addSubview:self.smallText];
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
    [self.largeText centerHorizonallyAtY:CGRectGetMaxY(self.titleText.frame)+15.0f inBounds:self.bounds thatFits:CGSizeUnbounded];
    [self.smallText centerHorizonallyAtY:CGRectGetMaxY(self.titleText.frame)+5.0f inBounds:self.bounds thatFits:CGSizeMake(paddedWidth, CGFLOAT_MAX)];

    CGFloat buttonHeight = [self.reminderButton sizeThatFits:CGSizeUnbounded].height;
    self.reminderButton.frame = CGRectMake(padding, CGRectGetMaxY(self.largeText.frame)+10.0f, paddedWidth, buttonHeight);
    
    CGFloat talkOffsetY = (self.largeText.hidden ? CGRectGetMaxY(self.smallText.frame)+15 :
                           (self.reminderButton.hidden ? self.reminderButton.frame.origin.y : CGRectGetMaxY(self.reminderButton.frame)+padding));
    self.talkButton.frame = CGRectMake(padding, talkOffsetY, paddedWidth, buttonHeight);
    self.moodsButton.frame = CGRectMake(padding, CGRectGetMaxY(self.talkButton.frame)+padding, paddedWidth, buttonHeight);
    self.infoButton.frame = CGRectMake(padding, self.moodsButton.frame.origin.y, paddedWidth, textButtonHeight);
    self.cancelButton.frame = CGRectMake(padding, CGRectGetMaxY(self.infoButton.frame)+padding, paddedWidth, textButtonHeight);
}

-(void)setStandardTitle:(NSString*)title hideReminders:(BOOL)hideReminders {
    self.titleText.text = title;
    self.largeText.hidden = NO;
    self.smallText.hidden = YES;
    self.reminderButton.hidden = hideReminders;
    self.moodsButton.hidden = NO;
    self.infoButton.hidden = YES;
    self.cancelButton.hidden = YES;
    [self.talkButton setTitle:@"TALK TO SOMEONE" forState:UIControlStateNormal];
    [self setNeedsLayout];
}

-(void)setAlternateTitle:(NSString*)title {
    self.titleText.text = title;
    self.largeText.hidden = YES;
    self.smallText.hidden = NO;
    self.reminderButton.hidden = YES;
    self.moodsButton.hidden = YES;
    self.infoButton.hidden = NO;
    self.cancelButton.hidden = NO;
    [self.talkButton setTitle:@"YES, LET'S TALK" forState:UIControlStateNormal];
    [self setNeedsLayout];
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

@end
