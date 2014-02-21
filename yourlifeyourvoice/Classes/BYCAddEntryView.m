#import "BYCAddEntryView.h"
#import "BYCUI.h"

@interface BYCAddEntryView()<UITextViewDelegate>
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UILabel *feelingLabel;
@property (nonatomic) UILabel *moodLabel;
@property (nonatomic) UIButton *addButton;
@property (nonatomic) UITextView *noteView;
@property (nonatomic) UIButton *saveButton;
@property (nonatomic) UIButton *deleteButton;
@property (nonatomic, weak) id<BYCAddEntryViewDelegate> delegate;
@end

@implementation BYCAddEntryView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.feelingLabel = [BYCUI labelWithRoundFontSize:12.0f];
        self.feelingLabel.textColor = [UIColor blackColor];
        self.feelingLabel.text = @"I'm feeling...";
        
        self.moodLabel = [BYCUI labelWithFontSize:20.0f];
        self.moodLabel.textColor = [UIColor blackColor];
        
        self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.addButton setImage:[UIImage imageNamed:@"icon_button_add"] forState:UIControlStateNormal];
        [self.addButton addTarget:self action:@selector(addSelected) forControlEvents:UIControlEventTouchUpInside];
        
        self.noteView = [[UITextView alloc] initWithFrame:CGRectZero];
        self.noteView.textColor = [UIColor blackColor];
        self.noteView.font = [BYCUI roundFontOfSize:14.0f];
        self.noteView.layer.borderWidth = 1.0f;
        self.noteView.layer.borderColor = [UIColor borderLightGray].CGColor;
        self.noteView.returnKeyType = UIReturnKeyDone;
        self.noteView.delegate = self;
        
        self.saveButton = [BYCUI standardButtonWithTitle:@"SAVE MOOD" target:self action:@selector(saveSelected)];
        self.deleteButton = [BYCUI deleteButtonWithTarget:self action:@selector(deleteSelected)];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        
        [self.scrollView addSubview:self.feelingLabel];
        [self.scrollView addSubview:self.moodLabel];
        [self.scrollView addSubview:self.addButton];
        [self.scrollView addSubview:self.noteView];
        [self.scrollView addSubview:self.saveButton];
        [self.scrollView addSubview:self.deleteButton];
        
        [self addSubview:self.scrollView];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = self.bounds.size.width;
    CGFloat padding = 10.0f;
    
    self.scrollView.frame = self.bounds;
    
    [self.feelingLabel centerHorizonallyAtY:0 inBounds:self.bounds thatFits:CGSizeUnbounded];
    [self.moodLabel centerHorizonallyAtY:CGRectGetMaxY(self.feelingLabel.frame) inBounds:self.bounds thatFits:CGSizeUnbounded];
    [self.addButton centerHorizonallyAtY:CGRectGetMaxY(self.moodLabel.frame)+5.0f inBounds:self.bounds thatFits:CGSizeUnbounded];
    [self.noteView setFrame:CGRectMake(padding, CGRectGetMaxY(self.addButton.frame)+padding, width-2*padding, 100)];
    
    CGSize saveSize = [self.saveButton sizeThatFits:CGSizeUnbounded];
    [self.saveButton setFrame:CGRectMake(padding, CGRectGetMaxY(self.noteView.frame)+padding, width-2*padding, saveSize.height)];
    [self.deleteButton centerHorizonallyAtY:CGRectGetMaxY(self.saveButton.frame)+padding inBounds:self.bounds thatFits:CGSizeUnbounded];
    
    [self.scrollView setContentSize:CGSizeMake(width, CGRectGetMaxY(self.deleteButton.frame)+padding)];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqual:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)setMoodText:(NSString*)text {
    self.moodLabel.text = [text uppercaseString];
    [self setNeedsLayout];
}

-(void)addSelected {
    [self.delegate addSelected];
}

-(void)saveSelected {
    [self.delegate saveSelected];
}

-(void)deleteSelected {
    [self.delegate deleteSelected];
}

@end
