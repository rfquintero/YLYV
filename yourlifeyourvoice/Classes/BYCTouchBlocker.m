#import "BYCTouchBlocker.h"
#import "BYCUI.h"

@interface BYCTouchBlocker()
@property (nonatomic) UIActivityIndicatorView *spinner;
@property (nonatomic) UILabel *label;
@end

@implementation BYCTouchBlocker

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
        
        self.label = [BYCUI labelWithFont:[UIFont boldSystemFontOfSize:16.0f]];
        self.label.textColor = [UIColor whiteColor];
        self.label.numberOfLines = 0;
        
        self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.spinner sizeToFit];
        
        [self addSubview:self.label];
        [self addSubview:self.spinner];
        
        self.hidden = YES;
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    [self.spinner centerInBounds:self.bounds offsetX:0 offsetY:0];
    
    CGSize labelSize = [self.label sizeThatFits:CGSizeMake(self.bounds.size.width-60, CGFLOAT_MAX)];
    [self.label centerHorizonallyAtY:self.spinner.frame.origin.y-20-labelSize.height inBounds:self.bounds withSize:labelSize];
}

-(void)show:(BOOL)show {
    self.hidden = !show;
    [self.superview bringSubviewToFront:self];
    if(show) {
        [self.spinner startAnimating];
    } else {
        [self.spinner stopAnimating];
    }
}

-(void)setText:(NSString*)text {
    self.label.text = text;
    [self setNeedsLayout];
}

@end
