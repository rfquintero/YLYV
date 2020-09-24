#import "BYCReminderView.h"
#import "BYCUI.h"

@interface BYCReminderView()
@property (nonatomic) UISwitch *switchView;
@property (nonatomic) UIButton *timeButton;
@property (nonatomic) UILabel *textButton;
@property (nonatomic) UIButton *blocker;
@property (nonatomic) UIDatePicker *picker;
@property (nonatomic, weak) id<BYCReminderViewDelegate> delegate;
@end

@implementation BYCReminderView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        [self.switchView addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
        
        self.timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.timeButton.layer.borderColor = [UIColor borderLightGray].CGColor;
        self.timeButton.layer.borderWidth = 1.0f;
        self.timeButton.titleLabel.font = [BYCUI roundFontOfSize:30.0f];
        self.timeButton.backgroundColor = [UIColor whiteColor];
        [self.timeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.timeButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [self.timeButton addTarget:self action:@selector(showPicker) forControlEvents:UIControlEventTouchUpInside];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicker)];
        self.textButton = [BYCUI labelWithRoundFontSize:14.0f];
        self.textButton.numberOfLines = 2;
        self.textButton.textAlignment = NSTextAlignmentCenter;
        [self.textButton addGestureRecognizer:recognizer];
        
        self.blocker = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.blocker addTarget:self action:@selector(hidePicker) forControlEvents:UIControlEventTouchUpInside];
        
        self.picker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
        [self.picker addTarget:self action:@selector(timeSelected) forControlEvents:UIControlEventValueChanged];
        self.picker.datePickerMode = UIDatePickerModeTime;
        if (@available(iOS 13.4, *)) {
            self.picker.preferredDatePickerStyle = UIDatePickerStyleWheels;
        }
        self.picker.minuteInterval = 1;
        self.picker.backgroundColor = [UIColor whiteColor];
        
        [self.scrollView addSubview:self.switchView];
        [self.scrollView addSubview:self.timeButton];
        [self.scrollView addSubview:self.textButton];
        [self addSubview:self.blocker];
        [self addSubview:self.picker];
        
        [self setPickerHidden:YES animated:NO];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat height = self.bounds.size.height;
    
    CGSize pickerSize = [self.picker sizeThatFits:CGSizeUnbounded];
    [self.picker centerHorizonallyAtY:(self.blocker.hidden ? height : height-pickerSize.height) inBounds:self.bounds withSize:CGSizeMake(self.bounds.size.width, pickerSize.height)];
    self.blocker.frame = CGRectMake(0, 0, self.bounds.size.width, height-pickerSize.height);
    
    [self.switchView centerHorizonallyAtY:40.0f inBounds:self.bounds thatFits:CGSizeUnbounded];
    [self.timeButton centerHorizonallyAtY:CGRectGetMaxY(self.switchView.frame)+40.0f inBounds:self.bounds withSize:CGSizeMake(150, 80)];
    [self.textButton centerHorizonallyAtY:CGRectGetMaxY(self.timeButton.frame)+40.0f inBounds:self.bounds thatFits:CGSizeMake(200, CGFLOAT_MAX)];
}

-(void)setActive:(BOOL)active {
    self.switchView.on = active;
    [self setNeedsLayout];
}

-(void)setTime:(BYCReminderTime*)time {
    [self.picker setDate:time.date animated:NO];
    self.switchView.on = time.active;
    self.textButton.attributedText = [self textForTime:time];

    [self.timeButton setTitle:time.string forState:UIControlStateNormal];
    self.timeButton.enabled = time.active;
    self.textButton.userInteractionEnabled = time.active;
    [self setNeedsLayout];
}

-(NSAttributedString*)textForTime:(BYCReminderTime*)time {
    if(time.active) {
        NSString *timeString = time.string;
        NSString *text = [NSString stringWithFormat:@"You will receive a daily reminder at %@.", timeString];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
        [str addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(str.length-1-timeString.length, timeString.length)];
        return str;
    } else {
        return [[NSAttributedString alloc] initWithString:@"You will not receive a reminder."];
    }
}

-(void)valueChanged {
    [self.delegate activeChanged:self.switchView.on];
}

-(void)timeSelected {
    [self.delegate timeSelected:self.picker.date];
}

-(void)showPicker {
    [self setPickerHidden:NO animated:YES];
}

-(void)hidePicker {
    [self setPickerHidden:YES animated:YES];
}

-(void)setPickerHidden:(BOOL)hidden animated:(BOOL)animated {
    if(animated) {
        self.picker.hidden = NO;
        self.blocker.hidden = hidden;
        [UIView animateWithDuration:0.3f animations:^{
            [self layoutSubviews];
        } completion:^(BOOL finished) {
            self.picker.hidden = hidden;
        }];
    } else {
        self.blocker.hidden = hidden;
        self.picker.hidden = hidden;
        [self setNeedsLayout];
    }
}

@end
