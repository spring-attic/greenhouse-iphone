//
//  Copyright 2010-2012 the original author or authors.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//
//  GreenhouseAppDelegate.m
//  Greenhouse
//
//  Created by Roy Clarkson on 6/7/10.
//

//#import <CoreLocation/CoreLocation.h>
#import "GreenhouseAppDelegate.h"
#import "GHAuthController.h"
#import "GHCoreDataManager.h"

@interface GreenhouseAppDelegate()

- (void)verifyLocationServices;

@end

@implementation GreenhouseAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize tabBarController;

- (void)showAuthorizeNavigationViewController
{	
	[tabBarController.view removeFromSuperview];
    [navigationController popToRootViewControllerAnimated:NO];
    [window addSubview:navigationController.view];
}

- (void)showTabBarController
{
    [navigationController.view removeFromSuperview];
	[window addSubview:tabBarController.view];
	tabBarController.selectedIndex = 0;
}

- (void)verifyLocationServices
{
//	if ([CLLocationManager locationServicesEnabled] == NO) 
//	{
//        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" 
//																		message:@"Greenhouse would like to use your current location but you currently have all location services disabled. If you proceed, you will be asked to confirm whether location services should be reenabled." 
//																	   delegate:nil 
//															  cancelButtonTitle:@"OK" 
//															  otherButtonTitles:nil];
//        [servicesDisabledAlert show];
//    }	
}


#pragma mark -
#pragma mark UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // sign out
    [GHAuthController deleteAccessGrant];
    [[GHCoreDataManager sharedInstance] deletePersistentStore];
    [self showAuthorizeNavigationViewController];    
}


#pragma mark -
#pragma mark UITabBarControllerDelegate methods

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
	
}


#pragma mark -
#pragma mark UIApplicationDelegate methods

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	DLog(@"");
	[[NSUserDefaults standardUserDefaults] synchronize];
	if ([GHUserSettings resetAppOnStart])
	{
		[GHAuthController deleteAccessGrant];
        [[GHCoreDataManager sharedInstance] deletePersistentStore];
		[GHUserSettings reset];
		[self showAuthorizeNavigationViewController];
	}
	else if ([GHAuthController isAuthorized])
	{
		[self showTabBarController];
	}
	else
	{
		[self showAuthorizeNavigationViewController];
	}
	
    [window makeKeyAndVisible];
	
	[GHUserSettings setAppVersion:[GHAppSettings appVersion]];
	[self verifyLocationServices];
    
	return;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	DLog(@"");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	DLog(@"");
	[[NSUserDefaults standardUserDefaults] synchronize];
	if ([GHUserSettings resetAppOnStart])
	{
		DLog(@"reset app");
		[GHAuthController deleteAccessGrant];
        [[GHCoreDataManager sharedInstance] deletePersistentStore];
		[GHUserSettings reset];
		[GHUserSettings setAppVersion:[GHAppSettings appVersion]];
		[self showAuthorizeNavigationViewController];
	}
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	DLog(@"");
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	DLog(@"");
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillTerminate:(UIApplication *)application 
{    
	DLog(@"");
}

@end

