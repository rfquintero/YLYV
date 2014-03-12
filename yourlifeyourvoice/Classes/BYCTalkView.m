#import "BYCTalkView.h"
#import "BYCUI.h"
#import "BYCConstants.h"

@interface BYCTalkView()
@property (nonatomic) UILabel *text;
@property (nonatomic) UIButton *call;
@property (nonatomic) UIButton *email;
@property (nonatomic) UIButton *chat;
@property (nonatomic) UIButton *message;
@property (nonatomic) UIButton *info;
@property (nonatomic, weak) id<BYCTalkViewDelegate> delegate;
@end

@implementation BYCTalkView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.text = [BYCUI labelWithFont:[UIFont systemFontOfSize:14.0f]];
        self.text.textColor = [UIColor blackColor];
        self.text.attributedText = [self talkText];
        self.text.numberOfLines = 0;
        
        self.info = [UIButton buttonWithType:UIButtonTypeCustom];
        self.info.backgroundColor = [UIColor clearColor];
        [self.info addTarget:self action:@selector(siteSelected) forControlEvents:UIControlEventTouchUpInside];
        
        self.call = [BYCUI standardButtonWithTitle:[NSString stringWithFormat:@"CALL %@", BYCPhoneNumber] target:self action:@selector(callSelected)];
        self.email = [BYCUI standardButtonWithTitle:@"EMAIL YLYV" target:self action:@selector(emailSelected)];
        self.chat = [BYCUI standardButtonWithTitle:@"START A CHAT" target:self action:@selector(chatSelected)];
        self.message = [BYCUI standardButtonWithTitle:@"SEND A TEXT" target:self action:@selector(textSelected)];
        
        [self.scrollView addSubview:self.text];
        [self.scrollView addSubview:self.info];
        [self.scrollView addSubview:self.call];
        [self.scrollView addSubview:self.email];
        [self.scrollView addSubview:self.chat];
        [self.scrollView addSubview:self.message];
    }
    return self;
}

-(NSAttributedString*)talkText {
    NSString *text1 = @"YourLifeYourVoice.org";
    NSString *text2 = @" is available to kids, teens, and young adults at anytime. Please contact us if you're depressed, contemplating suicide, being physically or sexually abused, on the run, addicted, threatened by gang violence, fighting with a friend or parent, or if you are faced with an overwhelming challenge.\n\n";
    NSString *text3 = @"You don't have to face your problems alone!";
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text1 attributes:@{NSForegroundColorAttributeName : [UIColor textOrange], NSFontAttributeName : [UIFont boldSystemFontOfSize:14.0f]}];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:text2 attributes:@{}]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:text3 attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:14.0f]}]];
    return str;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = self.bounds.size.width;
    CGFloat padding = 10.0f;
    CGFloat itemWidth = width-2*padding;
    CGFloat buttonHeight = [self.call sizeThatFits:CGSizeUnbounded].height;
    
    [self.text setFrameAtOrigin:CGPointMake(2*padding, padding) thatFits:CGSizeMake(width-4*padding, CGFLOAT_MAX)];
    self.info.frame = CGRectMake(padding, padding/2, width/2, 30);
    self.call.frame = CGRectMake(padding, CGRectGetMaxY(self.text.frame)+15.0f, itemWidth, buttonHeight);
    self.email.frame = CGRectMake(padding, CGRectGetMaxY(self.call.frame)+padding, itemWidth, buttonHeight);
    self.chat.frame = CGRectMake(padding, CGRectGetMaxY(self.email.frame)+padding, itemWidth, buttonHeight);
    self.message.frame = CGRectMake(padding, CGRectGetMaxY(self.chat.frame)+padding, itemWidth, buttonHeight);
    
    [self setContentHeight:CGRectGetMaxY(self.message.frame)+padding];
}

-(void)siteSelected {
    [self.delegate siteSelected];
}

-(void)callSelected {
    [self.delegate callSelected];
}

-(void)emailSelected {
    [self.delegate emailSelected];
}

-(void)chatSelected {
    [self.delegate chatSelected];
}

-(void)textSelected {
    [self.delegate textSelected];
}
@end
