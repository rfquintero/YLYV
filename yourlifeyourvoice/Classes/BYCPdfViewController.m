#import "BYCPdfViewController.h"
#import "BYCPdfView.h"

@interface BYCPdfViewController ()
@property (nonatomic) BYCPdfView *webView;
@property (nonatomic) NSString* filePath;
@end

@implementation BYCPdfViewController

-(id)initWithApplicationState:(BYCApplicationState *)applicationState filePath:(NSString*)path {
    if(self = [super initWithApplicationState:applicationState]) {
        self.filePath = path;
    }
    return self;
}

-(void)loadView {
    [super loadView];
    
    self.webView = [[BYCPdfView alloc] initWithFrame:self.view.frame];
    [self.navView setContentView:self.webView];
    [self.navView setNavTitle:@"PDF"];
    self.screenName = @"PDF Viewer";
    [self setupBackButton];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSURL *targetURL = [NSURL fileURLWithPath:self.filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [self.webView loadRequest:request];
}

@end
