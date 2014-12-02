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
#import "NSUserDefaults+DemoSettings.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Grab reference to storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey: @"existingUser"]) {
        self.window.rootViewController = [storyboard instantiateInitialViewController];
    } else {
        SetupUserViewController *setupViewController = [storyboard instantiateViewControllerWithIdentifier:@"SetupUserViewController"];
        [self.window makeKeyAndVisible];
        self.window.rootViewController = setupViewController;
    }
    
    [NSUserDefaults saveIncomingAvatarSetting:YES];
    [NSUserDefaults saveOutgoingAvatarSetting:YES];
    [NSUserDefaults saveEmptyMessagesSetting:YES];
    
    return YES;
}




@end
