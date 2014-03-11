#import "BYCTalkViewController.h"
#import "BYCTalkView.h"
#import <MessageUI/MessageUI.h>
#import "NSDate+Custom.h"

@interface BYCTalkViewController ()<BYCTalkViewDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>
@property (nonatomic) BYCTalkView *talkView;
@end

@implementation BYCTalkViewController

-(void)loadView {
    [super loadView];
    
    self.talkView = [[BYCTalkView alloc] initWithFrame:self.view.bounds];
    self.talkView.delegate = self;
    
    [self.navView setContentView:self.talkView];
    [self.navView setNavTitle:@"Talk"];
    [self setupMenuButton];
}

#pragma mark BYCTalkViewDelegate

-(void)callSelected {
    [self callYLYV];
}

-(void)emailSelected {
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *vc = [[MFMailComposeViewController alloc] init];
        [vc setSubject:@"My Mood"];
        [vc setToRecipients:@[@"yourlifeyourvoice@boystown.org"]];
        [vc setMailComposeDelegate:self];
        [self.navigationController presentViewController:vc animated:YES completion:^{}];
    } else {
        [self showError:@"Cannot send email" message:@"Email is not available. Please check your settings."];
    }
}

-(void)chatSelected {
    if([[NSDate date] isOnDays:@[@(2),@(3),@(4),@(5)] startHour:19 startMinute:30 endHour:23 endMinute:59]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.lifeline-chat.org/SightMaxAgentInterface/PreChatSurvey.aspx?accountID=5&siteID=8&queueID=17"]];
    } else {
        [self showError:@"Online Chat Unavailable" message:@"Chat will be available on Mondays - Thursdays from 7:30PM - 12:00 AM CDT. Please call or email."];
    }
}

-(void)textSelected {
    if([[NSDate date] isOnDays:@[@(2),@(4)] startHour:19 startMinute:00 endHour:23 endMinute:59]) {
        if([MFMessageComposeViewController canSendText]) {
            MFMessageComposeViewController *vc = [[MFMessageComposeViewController alloc] init];
            [vc setRecipients:@[@"20121"]];
            [vc setBody:@"VOICE"];
            [vc setMessageComposeDelegate:self];
            [self.navigationController presentViewController:vc animated:YES completion:^{}];
        } else {
            [self showError:@"Cannot send text" message:@"Messaging is not available. Please check your settings."];
        }
    } else {
        [self showError:@"Text Unavailable" message:@"Text will be available on Monday and Wednesday from 7:00PM - 12:00 AM CDT. Please call or email."];
    }
}

-(void)siteSelected {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:BYCWebSite]];
}

#pragma mark other

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [controller dismissViewControllerAnimated:YES completion:^{
    }];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
