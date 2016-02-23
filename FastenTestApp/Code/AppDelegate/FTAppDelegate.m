//
//  AppDelegate.m
//  FastenTestApp
//
//  Created by Kirill Kunst on 22.02.16.
//  Copyright © 2016 Kirill Kunst. All rights reserved.
//

#import "FTAppDelegate.h"
#import "FTStoryboards.h"
#import "FTAuthController.h"
#import "FTInformationViewController.h"
#import "FTServiceComponents.h"

#import <UIKit/UIKit.h>

@interface FTAppDelegate ()

@property (nonatomic, strong) FTServiceComponents *components;

@end

@implementation FTAppDelegate

#pragma mark - UIApplication Delegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupComponents];
    [self setupControllers];

    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

#pragma mark - Setup 

- (void)setupComponents
{
    self.components = [[FTServiceComponents alloc] init];
}

- (void)setupControllers
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    BOOL authenticated = [self.components.authService trySilentAuthentication];
    UINavigationController *shownController = nil;
    if (authenticated) {
        FTInformationViewController *infoController = [[FTStoryboards main] instantiateViewControllerWithIdentifier:NSStringFromClass([FTInformationViewController class])];
        infoController.authService = self.components.authService;
        shownController = (UINavigationController *)infoController;
    } else {
        FTAuthController *authController = [[FTStoryboards main] instantiateViewControllerWithIdentifier:NSStringFromClass([FTAuthController class])];
        authController.authService = self.components.authService;
        shownController = (UINavigationController *)authController;
    }
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:shownController];
    self.window.rootViewController = navController;
    self.window.backgroundColor = [UIColor whiteColor];
}

@end
