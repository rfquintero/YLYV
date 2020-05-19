#import "BYCPdfView.h"
#import "BYCNavigationView.h"
#import <WebKit/WebKit.h>

@interface BYCPdfView()
@property (nonatomic) WKWebView *webView;
@end

@implementation BYCPdfView

-(id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.webView = [[WKWebView alloc] initWithFrame:frame];
        
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
