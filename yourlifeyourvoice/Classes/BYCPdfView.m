#import "BYCPdfView.h"
#import "BYCNavigationView.h"

@interface BYCPdfView()
@property (nonatomic) UIWebView *webView;
@end

@implementation BYCPdfView

-(id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.webView = [[UIWebView alloc] initWithFrame:frame];
        self.webView.scalesPageToFit = YES;
        
        [self addSubview:self.webView];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat offset = [BYCNavigationView navbarHeight];
    self.webView.frame = CGRectMake(0, offset, self.bounds.size.width, self.bounds.size.height-offset);
}

-(void)loadRequest:(NSURLRequest*)request {
    [self.webView loadRequest:request];
}

@end
