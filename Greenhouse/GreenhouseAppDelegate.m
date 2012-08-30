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

#import <CoreLocation/CoreLocation.h>
#import "GreenhouseAppDelegate.h"
#import "GHAuthorizeNavigationViewController.h"
#import "GHOAuth2Controller.h"

@interface GreenhouseAppDelegate()

- (void)verifyLocationServices;

@end

@implementation GreenhouseAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize authorizeNavigationViewController;

- (void)showAuthorizeNavigationViewController
{	
	[tabBarController.view removeFromSuperview];
    [authorizeNavigationViewController.navigationController popToRootViewControllerAnimated:NO];
	[window addSubview:authorizeNavigationViewController.view];
}

- (void)showTabBarController
{
	[authorizeNavigationViewController.view removeFromSuperview];
	[window addSubview:tabBarController.view];
	tabBarController.selectedIndex = 0;
}

- (void)reloadDataForCurrentView
{
	if ([tabBarController isViewLoaded] && [tabBarController.selectedViewController respondsToSelector:@selector(reloadData)])
	{
		[tabBarController.selectedViewController performSelector:@selector(reloadData)];
	}	
}

- (void)verifyLocationServices
{
	if ([CLLocationManager locationServicesEnabled] == NO) 
	{
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" 
																		message:@"Greenhouse would like to use your current location but you currently have all location services disabled. If you proceed, you will be asked to confirm whether location services should be reenabled." 
																	   delegate:nil 
															  cancelButtonTitle:@"OK" 
															  otherButtonTitles:nil];
        [servicesDisabledAlert show];
    }	
}


#pragma mark -
#pragma mark UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1)
	{
		// sign out
		[[GHOAuth2Controller sharedInstance] deleteAccessGrant];
		[self showAuthorizeNavigationViewController];
	}
}


#pragma mark -
#pragma mark UITabBarControllerDelegate methods

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
	
}


#pragma mark -
#pragma mark UIApplicationDelegate methods

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	DLog(@"");	
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	DLog(@"");
		
	if ([GHUserSettings resetAppOnStart])
	{
		DLog(@"reset app");
		[[GHOAuth2Controller sharedInstance] deleteAccessGrant];
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
}

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	DLog(@"");
	
	if ([GHUserSettings resetAppOnStart])
	{
		[[GHOAuth2Controller sharedInstance] deleteAccessGrant];
		[GHUserSettings reset];
		[self showAuthorizeNavigationViewController];
	}	
	else if ([[GHOAuth2Controller sharedInstance] isAuthorized])
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

- (void)applicationWillTerminate:(UIApplication *)application 
{    
	DLog(@"");
}

@end

