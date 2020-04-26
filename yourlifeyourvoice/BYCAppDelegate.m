//
//  BYCAppDelegate.m
//  yourlifeyourvoice
//
//  Created by Ruben Quintero on 2/20/14.
//  Copyright (c) 2014 Banyan Communications. All rights reserved.
//

#import "BYCAppDelegate.h"
#import "BYCApplicationState.h"
#import "BYCSplitViewController.h"
#import "BYCEntryViewController.h"
#import "BYCEntry.h"
#import "BYCMigrationModel.h"
@import Firebase;

@interface BYCAppDelegate()<UIAlertViewDelegate>
@property (nonatomic) BYCApplicationState *applicationState;
@end

@implementation BYCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    application.applicationSupportsShakeToEdit = YES;
    
    [FIRApp configure];

    BYCSplitViewController *splitViewController = [[BYCSplitViewController alloc] init];
    BYCApplicationState *applicationState = [[BYCApplicationState alloc] initWithBlocker:splitViewController.blocker];
    self.applicationState = applicationState;
    splitViewController.applicationState = applicationState;
    
    UIViewController *vc = [[BYCEntryViewController alloc] initWithApplicationState:applicationState];
    splitViewController.mainViewController = vc;
    
    self.window.rootViewController = splitViewController;

    [BYCEntry createDirectories];
    [self launchCheck];
    
    
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)launchCheck {
    if([self.applicationState.database isFirstLaunch]) {
        if([BYCMigrationModel needsMigration:self.applicationState.database]) {
            [self.applicationState.blocker setText:@"Welcome to version 2.0!\n\nPlease wait while we import your existing entries."];
            BYCMigrationModel *model = [[BYCMigrationModel alloc] initWithDatabase:self.applicationState.database queue:self.applicationState.queue];
            [model performMigration:^{
                [self.applicationState.blocker setText:@""];
                [self showDisclaimer];
            }];
        } else {
            [self showDisclaimer];
        }
        
        [self.applicationState.database setLaunched];
    } else if(![self.applicationState.database isRated] && [self.applicationState.database getAllEntries].count >= 20) {
        [self showRatings];
        [self.applicationState.database setRated];
    }
}

-(void)showDisclaimer {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DISCLAIMER" message:@"You might be entering some personal information in this app. For your own privacy you might want to consider updating the security settings on your device." delegate:nil cancelButtonTitle:@"I Understand" otherButtonTitles:nil];
    [alert show];
}

-(void)showRatings {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please rate us!" message:@"We hope you enjoy using this app. We would love to get your feedback on the app store!" delegate:self cancelButtonTitle:@"No, Thanks" otherButtonTitles:@"Ok!", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(buttonIndex != alertView.cancelButtonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/app/appName/id626899759"]];
    }
}

@end
