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

@implementation BYCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    BYCApplicationState *applicationState = [[BYCApplicationState alloc] init];
    
    BYCSplitViewController *splitViewController = [[BYCSplitViewController alloc] initWithApplicationState:applicationState];
    
    UIViewController *vc = [[UIViewController alloc] init]; vc.title = @"Yay"; vc.view.backgroundColor = [UIColor blueColor];
    splitViewController.mainViewController = vc;
    
    self.window.rootViewController = splitViewController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
