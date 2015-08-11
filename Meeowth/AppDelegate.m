//
//  AppDelegate.m
//  MathGUI
//
//  Created by Kaige Liu on 5/6/15.
//  Copyright (c) 2015 Dustin Liu. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}


-(void)applicationWillResignActive:(UIApplication *)application
{
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    DesignViewController* desVC = [mainSB instantiateViewControllerWithIdentifier:@"DesignViewController"];
    [desVC save];
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    DesignViewController* desVC = [mainSB instantiateViewControllerWithIdentifier:@"DesignViewController"];
    [desVC save];}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    DesignViewController* desVC = [mainSB instantiateViewControllerWithIdentifier:@"DesignViewController"];
    [desVC save];}

@end
