#import "BYCAddEntryView.h"
#import "BYCUI.h"
#import "BYCNavigationView.h"

@interface BYCAddEntryView()<UITextViewDelegate>
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIView *backgroundView;
@property (nonatomic) UILabel *feelingLabel;
@property (nonatomic) UILabel *moodLabel;
@property (nonatomic) UIButton *addButton;
@property (nonatomic) UITextView *noteView;
@property (nonatomic) UIButton *saveButton;
@property (nonatomic) UIButton *deleteButton;

@property (nonatomic) CGFloat navHeight;
@property (nonatomic, weak) id<BYCAddEntryViewDelegate> delegate;
@end

@implementation BYCAddEntryView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.navHeight = [BYCNavigationView navbarHeight];
        
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        self.backgroundView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.3f];
        self.backgroundView.userInteractionEnabled = NO;
        
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
        self.scrollView.delegate = self;
        
        [self addSubview:self.scrollView];
        [self addSubview:self.backgroundView];
        [self addSubview:self.feelingLabel];
        [self addSubview:self.moodLabel];
        [self addSubview:self.addButton];
        [self.scrollView addSubview:self.noteView];
        [self.scrollView addSubview:self.saveButton];
        [self.scrollView addSubview:self.deleteButton];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    if(self.scrollView.isDragging || self.scrollView.isDecelerating) {
        return;
    }
    
    CGFloat width = self.bounds.size.width;
    CGFloat padding = 10.0f;
    
    self.scrollView.frame = self.bounds;
    
    CGFloat topHeight = [self layoutTop:NO]+padding;
    [self.noteView setFrame:CGRectMake(padding, self.contentOffset + topHeight, width-2*padding, 90)];
    
    CGSize saveSize = [self.saveButton sizeThatFits:CGSizeUnbounded];
    [self.saveButton setFrame:CGRectMake(padding, CGRectGetMaxY(self.noteView.frame)+padding, width-2*padding, saveSize.height)];
    [self.deleteButton centerHorizonallyAtY:CGRectGetMaxY(self.saveButton.frame)+padding inBounds:self.bounds thatFits:CGSizeUnbounded];
    
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, topHeight, 0);
    CGFloat scrollHeight = MAX(topHeight+self.bounds.size.height-44, CGRectGetMaxY(self.deleteButton.frame)+padding);
    [self.scrollView setContentSize:CGSizeMake(width, scrollHeight)];
}

-(CGFloat)minOffset {
    return self.navHeight + 17.0f;
}

-(CGFloat)layoutTop:(BOOL)scrolling {
    CGFloat minOffset = self.minOffset;
    CGFloat offset = MAX(self.contentOffset - self.scrollView.contentOffset.y, minOffset);
    
    [self.feelingLabel centerHorizonallyAtY:offset inBounds:self.bounds thatFits:CGSizeUnbounded];
    [self.moodLabel centerHorizonallyAtY:CGRectGetMaxY(self.feelingLabel.frame) inBounds:self.bounds thatFits:CGSizeUnbounded];
    [self.addButton centerHorizonallyAtY:CGRectGetMaxY(self.moodLabel.frame)+5.0f inBounds:self.bounds thatFits:CGSizeUnbounded];
    
    self.backgroundView.frame = CGRectMake(0, self.navHeight, self.bounds.size.width, self.addButton.center.y-self.navHeight);
    if(scrolling) {
        [self.delegate offsetChanged:(offset-minOffset)/(self.contentOffset-minOffset)];
    }
    return CGRectGetMaxY(self.addButton.frame) - offset;
}

#pragma mark UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self layoutTop:YES];
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

-(void)setContentOffset:(CGFloat)offset {
    _contentOffset = offset;
    [self setNeedsLayout];
}

-(void)resetContent {
    [self.scrollView setContentOffset:CGPointZero animated:NO];
    [self layoutSubviews];
}

#pragma mark callbacks

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
