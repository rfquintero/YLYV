#import "BYCInfoView.h"
#import "BYCUI.h"

@interface BYCInfoView()
@property (nonatomic) UIImageView *logo;
@property (nonatomic) UILabel *text;
@property (nonatomic) UIButton *talkButton;
@property (nonatomic) UIButton *siteButton;
@property (nonatomic, weak) id<BYCInfoViewDelegate> delegate;
@end

@implementation BYCInfoView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_logo"]];
        self.text = [BYCUI labelWithFont:[UIFont systemFontOfSize:14.0f]];
        self.text.text = @"Your Life Your Voice is a project sponsored by The Boys Town National Hotline, a toll free number available to kids, teens and young adults at anytime. Please contact us if you're depressed, contemplating suicide, being physically or sexually abused, on the run, addicted, threatened by gang violence, fighting with a friend or parent, or if you are faced with an overwhelming challenge.";
        self.text.numberOfLines = 0;
        
        self.talkButton = [BYCUI standardButtonWithTitle:@"TALK TO SOMEONE" target:self action:@selector(talkSelected)];
        self.siteButton = [BYCUI standardButtonWithTitle:@"YourLifeYourVoice.ORG" target:self action:@selector(siteSelected)];
        
        [self.scrollView addSubview:self.logo];
        [self.scrollView addSubview:self.text];
        [self.scrollView addSubview:self.talkButton];
        [self.scrollView addSubview:self.siteButton];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat padding = 10.0f;
    CGFloat width = self.bounds.size.width;
    CGFloat buttonHeight = [self.talkButton sizeThatFits:CGSizeUnbounded].height;
    CGFloat buttonWidth = width-2*padding;
    
    [self.logo centerHorizonallyAtY:0 inBounds:self.bounds thatFits:CGSizeUnbounded];
    [self.text centerHorizonallyAtY:CGRectGetMaxY(self.logo.frame)+10 inBounds:self.bounds thatFits:CGSizeMake(width-30, CGFLOAT_MAX)];
    self.talkButton.frame = CGRectMake(padding, CGRectGetMaxY(self.text.frame)+20, buttonWidth, buttonHeight);
    self.siteButton.frame = CGRectMake(padding, CGRectGetMaxY(self.talkButton.frame)+10, buttonWidth, buttonHeight);
    
    [self setContentHeight:CGRectGetMaxY(self.siteButton.frame)+10.0f];
}

-(void)talkSelected {
    [self.delegate talkSelected];
}

-(void)siteSelected {
    [self.delegate siteSelected];
}

@end
