#import "BYCSafetyPlanViewController.h"
#import "BYCSafetyPlanView.h"
#import "BYCPdfViewController.h"
#import <MessageUI/MessageUI.h>

@interface BYCSafetyPlanViewController ()<BYCSafetyPlanViewDelegate, MFMailComposeViewControllerDelegate>
@property (nonatomic) BYCSafetyPlanView *mainView;
@end

@implementation BYCSafetyPlanViewController

-(void)loadView {
    [super loadView];
    
    self.mainView = [[BYCSafetyPlanView alloc] initWithFrame:self.view.bounds];
    self.mainView.delegate = self;
    
    [self.navView setContentView:self.mainView];
    [self.navView setNavTitle:@"Safety Plan"];
    self.screenName = @"Safety Plan";
    [self setupMenuButton];
}
 
-(void)emailSelected {
    [self trackEvent:BYCTrackingContact action:@"email" label:@"safety plan"];
    if([MFMailComposeViewController canSendMail]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"safety_plan" ofType:@"pdf"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        
        MFMailComposeViewController *vc = [[MFMailComposeViewController alloc] init];
        [vc setSubject:@"Safety Plan"];
        [vc addAttachmentData:data mimeType:@"application/pdf" fileName:@"safety_plan.pdf"];
        [vc setMailComposeDelegate:self];
        [self.navigationController presentViewController:vc animated:YES completion:^{}];
    } else {
        [self showError:@"Cannot send email" message:@"Email is not available. Please check your settings."];
    }
}

- (void)exampleSelected {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"safety_plan" ofType:@"pdf"];
    
    BYCPdfViewController *vc = [[BYCPdfViewController alloc] initWithApplicationState:self.applicationState filePath:path];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark other

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:^{
    }];
}
@end
