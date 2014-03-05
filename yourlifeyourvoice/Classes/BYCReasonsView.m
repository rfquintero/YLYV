#import "BYCReasonsView.h"
#import "BYCUI.h"

@interface BYCReasonsView()
@property (nonatomic) UILabel *title;
@property (nonatomic) UILabel *label;
@property (nonatomic, readwrite) BOOL hasContent;
@end

@implementation BYCReasonsView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.title = [BYCUI labelWithRoundFontSize:14.0f];
        self.title.text = @"because of...";
        self.title.textColor = [UIColor blackColor];
        
        self.label = [BYCUI labelWithFont:[UIFont systemFontOfSize:13.0f]];
        self.label.numberOfLines = 0;
        self.label.textColor = [UIColor blackColor];
        self.label.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:self.title];
        [self addSubview:self.label];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self.title centerHorizonallyAtY:0 inBounds:self.bounds thatFits:CGSizeUnbounded];
    [self.label centerHorizonallyAtY:CGRectGetMaxY(self.title.frame)+5 inBounds:self.bounds thatFits:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX)];
}

-(CGSize)sizeThatFits:(CGSize)size {
    CGSize titleSize = [self.title sizeThatFits:size];
    CGSize reasonsSize = [self.label sizeThatFits:size];
    return CGSizeMake(size.width, titleSize.height + reasonsSize.height+5);
}

-(void)setReasons:(NSArray*)reasons {
    _hasContent = reasons.count > 0;
    NSString *text = [[reasons componentsJoinedByString:@", "] lowercaseString];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSUInteger index = 0;
    for(NSString *reason in reasons) {
        [str addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(index, reason.length)];
        index += reason.length + 2;
    }
    
    self.label.attributedText = str;
}

@end
