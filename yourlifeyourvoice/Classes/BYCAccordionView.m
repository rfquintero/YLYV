#import "BYCAccordionView.h"
#import "BYCAccordionHeaderView.h"
#import "BYCUI.h"

@interface BYCAccordionView()
@property (nonatomic) BYCAccordionHeaderView *header;
@property (nonatomic) UILabel *text;
@property (nonatomic) BOOL showing;
@end

@implementation BYCAccordionView

-(id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.header = [[BYCAccordionHeaderView alloc] initWithFrame:CGRectZero];
        [self.header addTarget:self action:@selector(headerTapped) forControlEvents:UIControlEventTouchUpInside];
        
        self.text = [BYCUI labelWithFont:[UIFont systemFontOfSize:14.0f]];
        self.text.numberOfLines = 0;
        
        [self setShowing:NO animated:NO];
        
        [self addSubview:self.header];
        [self addSubview:self.text];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = self.bounds.size.width;
    [self.header setFrameAtOrigin:CGPointMake(0, 0) thatFits:CGSizeMake(width, CGFLOAT_MAX)];
    
    [self.text setFrameAtOrigin:CGPointMake(10, CGRectGetMaxY(self.header.frame)+10.0f) thatFits:CGSizeMake(width-20, CGFLOAT_MAX)];
}

-(CGSize)sizeThatFits:(CGSize)size {
    CGFloat height = [self.header sizeThatFits:size].height;
    if(self.showing) {
        height += [self.text sizeThatFits:CGSizeMake(size.width-20, size.height)].height;
        height += 20.0f;
    }
    return CGSizeMake(size.width, height);
}

-(void)headerTapped {
    [self.delegate accordionView:self tappedWhenShowing:self.showing];
}

-(void)setShowing:(BOOL)showing animated:(BOOL)animated {
    _showing = showing;
    [self.header setShowing:showing animated:animated];
    if(animated) {
        self.text.hidden = NO;
        [UIView animateWithDuration:0.2f animations:^{
            self.text.alpha = showing ? 1.0f : 0.0f;
        } completion:^(BOOL finished) {
            self.text.hidden = showing ? NO : YES;
        }];
    } else {
        self.text.hidden = !showing;
        self.text.alpha = showing ? 1.0f : 0.0f;
    }
}

-(void)setTitle:(NSString*)title text:(NSString*)text {
    [self.header setTitle:title forState:UIControlStateNormal];
    [self.text setText:text];
    
    [self setNeedsLayout];
}

@end
