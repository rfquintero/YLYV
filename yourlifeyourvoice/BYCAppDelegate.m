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

@implementation BYCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    BYCSplitViewController *splitViewController = [[BYCSplitViewController alloc] init];
    BYCApplicationState *applicationState = [[BYCApplicationState alloc] initWithBlocker:splitViewController.blocker];
    splitViewController.applicationState = applicationState;
    
    UIViewController *vc = [[BYCEntryViewController alloc] initWithApplicationState:applicationState];
    splitViewController.mainViewController = vc;
    
    self.window.rootViewController = splitViewController;

    [BYCEntry createDirectories];
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
