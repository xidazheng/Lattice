//
//  AppDelegate.m
//  Lattice
//
//  Created by Elliott French on 22/11/2014.
//  Copyright (c) 2014 XidaElliott. All rights reserved.
//

#import "AppDelegate.h"
#import "User.h"
#import "MCManager.h"
#import "SetupUserViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
//    NSString *username = (arc4random() %2 == 0) ? @"Xida" : @"Elliot";
//    User *user = [[User alloc]initWithUsername:username];
//    NSData *encodedUser = [NSKeyedArchiver archivedDataWithRootObject:user];
//    [[NSUserDefaults standardUserDefaults] setObject:encodedUser forKey:@"user"];
//    
//    MCManager *manager = [[MCManager alloc] init];
//    [manager setupPeerAndSessionWithDisplayName:username];
//    [manager setupMCBrowser];
//    [manager advertiseSelf:YES];
    
    // Grab reference to storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey: @"existingUser"]) {
        self.window.rootViewController = [storyboard instantiateInitialViewController];
    } else {
        SetupUserViewController *setupViewController = [storyboard instantiateViewControllerWithIdentifier:@"SetupUserViewController"];
        [self.window makeKeyAndVisible];
        self.window.rootViewController = setupViewController;
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
