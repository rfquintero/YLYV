#import "BYCContentView.h"
#import "BYCUI.h"

@interface BYCContentView()
@property (nonatomic, readwrite) UIScrollView *scrollView;
@end

@implementation BYCContentView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        self.scrollView.backgroundColor = [UIColor bgLightGray];
        self.scrollView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
        
        [self addSubview:self.scrollView];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
}

-(void)setContentHeight:(CGFloat)height {
    self.scrollView.contentSize = CGSizeMake(self.bounds.size.width, height);
}

@end
