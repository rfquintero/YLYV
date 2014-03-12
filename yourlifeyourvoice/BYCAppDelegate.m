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

@interface BYCAppDelegate()
@property (nonatomic) BYCApplicationState *applicationState;
@end

@implementation BYCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    application.applicationSupportsShakeToEdit = YES;

    BYCSplitViewController *splitViewController = [[BYCSplitViewController alloc] init];
    BYCApplicationState *applicationState = [[BYCApplicationState alloc] initWithBlocker:splitViewController.blocker];
    self.applicationState = applicationState;
    splitViewController.applicationState = applicationState;
    
    UIViewController *vc = [[BYCEntryViewController alloc] initWithApplicationState:applicationState];
    splitViewController.mainViewController = vc;
    
    self.window.rootViewController = splitViewController;

    [BYCEntry createDirectories];
    [self firstLaunchCheck];
    
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)firstLaunchCheck {
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
    }
}

-(void)showDisclaimer {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DISCLAIMER" message:@"You might be entering some personal information in this app. For your own privacy you might want to consider updating the security settings on your device." delegate:nil cancelButtonTitle:@"I Understand" otherButtonTitles:nil];
    [alert show];
}

@end
