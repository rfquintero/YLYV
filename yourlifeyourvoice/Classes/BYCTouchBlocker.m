#import "BYCTouchBlocker.h"
#import "BYCUI.h"

@interface BYCTouchBlocker()
@property (nonatomic) UIActivityIndicatorView *spinner;
@end

@implementation BYCTouchBlocker

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
        
        self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.spinner sizeToFit];
        
        [self addSubview:self.spinner];
        
        self.hidden = YES;
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self.spinner centerInBounds:self.bounds offsetX:0 offsetY:0];
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

@end
