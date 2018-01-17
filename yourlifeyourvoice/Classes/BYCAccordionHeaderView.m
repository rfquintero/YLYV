#import "BYCAccordionHeaderView.h"
#import "BYCUI.h"

@interface BYCAccordionHeaderView()
@property (nonatomic) UIImageView *arrow;
@end

@implementation BYCAccordionHeaderView

-(id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        self.backgroundColor = [UIColor bgAccordion];
        self.arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_up"]];
        
        [self addSubview:self.arrow];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = self.bounds.size.width;
    CGFloat padding = 10.0f;
    CGSize arrowSize = CGSizeMake(20, 20);
    
    CGFloat arrowX = width-padding-arrowSize.width;
    [self.arrow centerVerticallyAtX:arrowX inBounds:self.bounds withSize:arrowSize];
    [self.titleLabel centerVerticallyAtX:padding inBounds:self.bounds withWidth:arrowX -2*padding];
}

-(CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(size.width, 40);
}

-(void)setShowing:(BOOL)showing animated:(BOOL)animated {
    if(animated) {
        [UIView animateWithDuration:0.2f animations:^{
            self.arrow.transform = showing ? CGAffineTransformMakeRotation(M_PI) : CGAffineTransformIdentity;
        }];
    } else {
        self.arrow.transform = showing ? CGAffineTransformMakeRotation(M_PI) : CGAffineTransformIdentity;
    }
}

@end
