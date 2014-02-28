#import "BYCAddEntryView.h"
#import "BYCUI.h"
#import "BYCNavigationView.h"
#import "BYCActionView.h"
#import "BYCImageButton.h"
#import "BYCReasonsView.h"

typedef enum {
    Action_Because,
    Action_Photo,
    Action_Audio,
} ActionItem;

@interface BYCAddEntryView()<UITextViewDelegate, BYCActionViewDelegate>
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIView *backgroundView;
@property (nonatomic) UILabel *feelingLabel;
@property (nonatomic) UILabel *moodLabel;
@property (nonatomic) BYCImageButton *addButton;
@property (nonatomic) BYCReasonsView *reasonsView;
@property (nonatomic) BYCImageButton *photo;
@property (nonatomic) UITextView *noteView;
@property (nonatomic) UIButton *saveButton;
@property (nonatomic) UIButton *deleteButton;
@property (nonatomic) BYCActionView *actionView;
@property (nonatomic) UITapGestureRecognizer *tapRecognizer;

@property (nonatomic) BOOL showAction;
@property (nonatomic) CGFloat navHeight;
@property (nonatomic, weak) id<BYCAddEntryViewDelegate> delegate;
@end

@implementation BYCAddEntryView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.navHeight = [BYCNavigationView navbarHeight];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
        [self addGestureRecognizer:tap];
        self.tapRecognizer = tap;
        
        UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        self.backgroundView.backgroundColor = [[UIColor bgBlue] colorWithAlphaComponent:0.9f];
        self.backgroundView.userInteractionEnabled = NO;
        [self.backgroundView addGestureRecognizer:bgTap];
        
        self.feelingLabel = [BYCUI labelWithRoundFontSize:14.0f];
        self.feelingLabel.textColor = [UIColor blackColor];
        self.feelingLabel.text = @"I'm feeling...";
        
        self.moodLabel = [BYCUI labelWithFontSize:22.0f];
        self.moodLabel.textColor = [UIColor blackColor];
        
        self.addButton = [[BYCImageButton alloc] initWithFrame:CGRectZero];
        [self.addButton setImage:[UIImage imageNamed:@"icon_button_add"]];
        [self.addButton addTarget:self action:@selector(addSelected) forControlEvents:UIControlEventTouchUpInside];
        
        self.reasonsView = [[BYCReasonsView alloc] initWithFrame:CGRectZero];
        UITapGestureRecognizer *reasonsTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(becauseSelected)];
        [self.reasonsView addGestureRecognizer:reasonsTap];
        self.reasonsView.hidden = YES;
        
        self.photo = [[BYCImageButton alloc] initWithFrame:CGRectZero];
        self.photo.customImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.photo addTarget:self action:@selector(photoSelected) forControlEvents:UIControlEventTouchUpInside];
        self.photo.hidden = YES;
        
        self.noteView = [[UITextView alloc] initWithFrame:CGRectZero];
        self.noteView.textColor = [UIColor blackColor];
        self.noteView.font = [BYCUI roundFontOfSize:14.0f];
        self.noteView.layer.borderWidth = 1.0f;
        self.noteView.layer.borderColor = [UIColor borderLightGray].CGColor;
        self.noteView.delegate = self;
        
        self.saveButton = [BYCUI standardButtonWithTitle:@"SAVE MOOD" target:self action:@selector(saveSelected)];
        self.deleteButton = [BYCUI deleteButtonWithTarget:self action:@selector(deleteSelected)];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        self.scrollView.delegate = self;
        
        self.actionView = [[BYCActionView alloc] initWithFrame:CGRectZero];
        self.actionView.delegate = self;
        [self.actionView addTitle:@"because of..." withTag:Action_Because];
        [self.actionView addTitle:@"Add Photo" withTag:Action_Photo];
        [self.actionView addTitle:@"Record Voice" withTag:Action_Audio];
        
        [self addSubview:self.scrollView];
        [self addSubview:self.backgroundView];
        [self addSubview:self.actionView];
        [self addSubview:self.feelingLabel];
        [self addSubview:self.moodLabel];
        [self addSubview:self.addButton];
        [self.scrollView addSubview:self.reasonsView];
        [self.scrollView addSubview:self.photo];
        [self.scrollView addSubview:self.noteView];
        [self.scrollView addSubview:self.saveButton];
        [self.scrollView addSubview:self.deleteButton];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardUp:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDown) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged) name:UITextViewTextDidChangeNotification object:self.noteView];
    }
    return self;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    if(self.scrollView.isDragging || self.scrollView.isDecelerating) {
        return;
    }
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat padding = 10.0f;
    CGFloat paddedWidth = width-2*padding;
    
    self.scrollView.frame = self.bounds;
    
    CGFloat topHeight = [self layoutTop:NO]+padding;
    CGFloat offsetY = self.contentOffset + topHeight;
    [self.reasonsView centerHorizonallyAtY:offsetY inBounds:self.bounds thatFits:CGSizeMake(paddedWidth, CGFLOAT_MAX)];
    offsetY = [self offset:offsetY belowView:self.reasonsView];
    [self.photo setFrame:CGRectMake(padding, offsetY, paddedWidth, paddedWidth)];
    offsetY = [self offset:offsetY belowView:self.photo];
    [self.noteView setFrame:CGRectMake(padding, offsetY, paddedWidth, 90)];
    
    CGSize saveSize = [self.saveButton sizeThatFits:CGSizeUnbounded];
    [self.saveButton setFrame:CGRectMake(padding, CGRectGetMaxY(self.noteView.frame)+padding, paddedWidth, saveSize.height)];
    [self.deleteButton centerHorizonallyAtY:CGRectGetMaxY(self.saveButton.frame)+padding inBounds:self.bounds thatFits:CGSizeUnbounded];
    
    CGFloat scrollHeight = MAX(height+self.contentOffset-self.minOffset, CGRectGetMaxY(self.deleteButton.frame)+padding);
    [self.scrollView setContentSize:CGSizeMake(width, scrollHeight)];
    
    CGFloat actionHeight = (height-topHeight-padding-self.addButton.frame.size.height/2);
    if(self.showAction) {
        self.actionView.frame = CGRectMake(0, self.addButton.center.y, width, actionHeight);
    } else {
        self.actionView.frame = CGRectMake(0, height, width, actionHeight);
    }
}

-(CGFloat)offset:(CGFloat)offset belowView:(UIView*)view {
    return (view.hidden ? offset : CGRectGetMaxY(view.frame) + 20.0f);
}

-(CGFloat)minOffset {
    return self.navHeight + 10.0f;
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

-(void)setImage:(UIImage *)image {
    self.photo.image = image;
    self.photo.hidden = !image;
    [self setNeedsLayout];
}

-(void)setReasons:(NSArray*)reasons {
    [self.reasonsView setReasons:reasons];
    self.reasonsView.hidden = reasons.count == 0;
    [self setNeedsLayout];
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

-(void)scrollToTop:(BOOL)animated {
    CGFloat offset = self.contentOffset - self.minOffset;
    if(self.scrollView.contentOffset.y < offset) {
        [self.scrollView setContentOffset:CGPointMake(0, self.contentOffset-self.minOffset) animated:animated];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self layoutTop:YES];
}

-(void)setActionSheetVisible:(BOOL)visible completion:(void (^)())completion {
    if(visible != _showAction) {
        _showAction = visible;
        if(self.showAction) {
            [self scrollToTop:YES];
        }
        self.scrollView.scrollEnabled = !self.showAction;
        self.buttonsEnabled = !self.showAction;
        self.addButton.userInteractionEnabled = YES;
        self.backgroundView.userInteractionEnabled = self.showAction;
        self.tapRecognizer.enabled = !self.showAction;
        [UIView animateWithDuration:0.3f animations:^{
            [self layoutSubviews];
            self.addButton.imageTransform = self.showAction ? CGAffineTransformConcat(CGAffineTransformIdentity, CGAffineTransformMakeRotation(M_PI/4.0f)) : CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            completion();
        }];
    }
}

#pragma mark callbacks

-(void)photoSelected {
    [self.delegate photoSelected];
}

-(void)becauseSelected {
    [self.delegate becauseSelected];
}

-(void)addSelected {
    [self setActionSheetVisible:!self.showAction completion:^{ }];
}

-(void)saveSelected {
    [self.delegate saveSelected];
}

-(void)deleteSelected {
    [self.delegate deleteSelected];
}

-(void)actionSelectedWithTag:(NSInteger)tag {
    __block id<BYCAddEntryViewDelegate> delegate = self.delegate;
    [self setActionSheetVisible:NO  completion:^{
        switch(tag) {
            case Action_Audio:
                [delegate audioSelected];
                break;
            case Action_Because:
                [delegate becauseSelected];
                break;
            case Action_Photo:
                [delegate photoSelected];
                break;
            default:
                break;
        }
    }];
}

-(void)textChanged {
    [self.delegate noteChanged:self.noteView.text];
}

#pragma mark keyboard

-(void)hideKeyboard {
    [self.noteView resignFirstResponder];
    [self setActionSheetVisible:NO completion:^{ }];
}

-(void)setButtonsEnabled:(BOOL)enabled {
    self.addButton.userInteractionEnabled = enabled;
    self.deleteButton.userInteractionEnabled = enabled;
    self.photo.userInteractionEnabled = enabled;
    self.reasonsView.userInteractionEnabled = enabled;
    [self.delegate setNavActive:enabled];
}

-(void)keyboardUp:(NSNotification*)notification {
    CGFloat keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat extraHeight = self.scrollView.contentSize.height - CGRectGetMaxY(self.deleteButton.frame)+10.0f;
    CGFloat offset = self.contentOffset - self.minOffset;
    if(extraHeight < keyboardHeight) {
        [UIView animateWithDuration:0.3f animations:^{
            self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight-extraHeight, 0);
        } completion:^(BOOL finished) {
            [self.scrollView setContentOffset:CGPointMake(0, self.noteView.frame.origin.y-offset) animated:YES];
        }];
    } else {
        [self.scrollView setContentOffset:CGPointMake(0, self.noteView.frame.origin.y-offset) animated:YES];
    }
    self.buttonsEnabled = NO;
}

-(void)keyboardDown {
    self.buttonsEnabled = YES;
    [UIView animateWithDuration:0.3f animations:^{
        self.scrollView.contentInset = UIEdgeInsetsZero;
    }];
}

@end
