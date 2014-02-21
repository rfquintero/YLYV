#import "BYCTalkView.h"
#import "BYCUI.h"

@interface BYCTalkView()
@property (nonatomic) UILabel *text;
@property (nonatomic) UIButton *learnMore;
@property (nonatomic) UIButton *call;
@property (nonatomic) UIButton *email;
@property (nonatomic) UIButton *chat;
@end

@implementation BYCTalkView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.text = [BYCUI labelWithRoundFontSize:14.0f];
        self.text.textColor = [UIColor blackColor];
        self.text.attributedText = [self talkText];
        self.text.numberOfLines = 0;
        
        self.learnMore = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.learnMore setTitle:@"Learn More." forState:UIControlStateNormal];
        [self.learnMore setTitleColor:[UIColor textOrange] forState:UIControlStateNormal];
        [self.learnMore addTarget:self action:@selector(learnMoreSelected) forControlEvents:UIControlEventTouchUpInside];
        
        self.call = [BYCUI standardButtonWithTitle:@"CALL" target:self action:@selector(callSelected)];
        self.email = [BYCUI standardButtonWithTitle:@"EMAIL" target:self action:@selector(emailSelected)];
        self.chat = [BYCUI standardButtonWithTitle:@"CHAT" target:self action:@selector(chatSelected)];
        
        [self.scrollView addSubview:self.text];
        [self.scrollView addSubview:self.learnMore];
        [self.scrollView addSubview:self.call];
        [self.scrollView addSubview:self.email];
        [self.scrollView addSubview:self.chat];
    }
    return self;
}

-(NSAttributedString*)talkText {
    NSString *text1 = @"Relationships, bullies, school, and family stuff can really add a lot of stress. You are not alone. Counselors at ";
    NSString *text2 = @"YourLife, YourVoice ";
    NSString *text3 = @"are here to talk 24/7";
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text1 attributes:@{}];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:text2 attributes:@{ NSForegroundColorAttributeName : [UIColor textOrange]}]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:text3]];
    return str;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = self.bounds.size.width;
    CGFloat padding = 10.0f;
    CGFloat itemWidth = width-2*padding;
    CGFloat buttonHeight = [self.call sizeThatFits:CGSizeUnbounded].height;
    
    [self.text setFrameAtOrigin:CGPointMake(padding, padding) thatFits:CGSizeMake(itemWidth, CGFLOAT_MAX)];
    [self.learnMore setFrameAtOrigin:CGPointMake(padding, CGRectGetMaxY(self.text.frame)+20.0f) thatFits:CGSizeUnbounded];
    self.call.frame = CGRectMake(padding, CGRectGetMaxY(self.learnMore.frame)+15.0f, itemWidth, buttonHeight);
    self.email.frame = CGRectMake(padding, CGRectGetMaxY(self.call.frame)+padding, itemWidth, buttonHeight);
    self.chat.frame = CGRectMake(padding, CGRectGetMaxY(self.email.frame)+padding, itemWidth, buttonHeight);
}


-(void)learnMoreSelected {
    
}

-(void)callSelected {
    
}

-(void)emailSelected {
    
}

-(void)chatSelected {
    
}
@end
