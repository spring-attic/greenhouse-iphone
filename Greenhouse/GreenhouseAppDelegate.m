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
#import "AuthorizeViewController.h"
#import "OAuthManager.h"


@interface GreenhouseAppDelegate()

- (void)verifyLocationServices;

@end


@implementation GreenhouseAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize authorizeViewController;

- (void)showAuthorizeViewController
{	
	[tabBarController.view removeFromSuperview];
	[window addSubview:authorizeViewController.view];
}

- (void)showTabBarController
{
	[authorizeViewController.view removeFromSuperview];
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

- (void)processOauthResponseDidFinish
{
	[self showTabBarController];
	[self reloadDataForCurrentView];
}

- (void)processOauthResponseDidFail
{
	[self showAuthorizeViewController];
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
        [servicesDisabledAlert release];
    }	
}


#pragma mark -
#pragma mark UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1)
	{
		// sign out
		[[OAuthManager sharedInstance] removeAccessToken];
		[self showAuthorizeViewController];
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
		
	if ([UserSettings resetAppOnStart])
	{
		DLog(@"reset app");
		[[OAuthManager sharedInstance] removeAccessToken];
		[UserSettings reset];
		[UserSettings setAppVersion:[AppSettings appVersion]];
		[self showAuthorizeViewController];
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

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
	if (url)
	{
		OAuthManager *mgr = [OAuthManager sharedInstance];
		[mgr processOauthResponse:url 
						 delegate:self 
				didFinishSelector:@selector(processOauthResponseDidFinish)
				  didFailSelector:@selector(processOauthResponseDidFail)];
	}

	return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	DLog(@"");
	
	if ([UserSettings resetAppOnStart])
	{
		[[OAuthManager sharedInstance] removeAccessToken];
		[UserSettings reset];
		[self showAuthorizeViewController];
	}	
	else if (launchOptions)
	{
		NSURL *url = (NSURL *)[launchOptions objectForKey:@"UIApplicationLaunchOptionsURLKey"];
		
		if (url)
		{
			OAuthManager *mgr = [OAuthManager sharedInstance];
			[mgr processOauthResponse:url 
							 delegate:self 
					didFinishSelector:@selector(processOauthResponseDidFinish)
					  didFailSelector:@selector(processOauthResponseDidFail)];
		}
		else
		{
			[self showAuthorizeViewController];
		}
	}
	else if ([[OAuthManager sharedInstance] isAuthorized])
	{
		[self showTabBarController];
	}
	else 
	{
		[self showAuthorizeViewController];
	}
	
    [window makeKeyAndVisible];
	
	[UserSettings setAppVersion:[AppSettings appVersion]];
	[self verifyLocationServices];

	return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application 
{    
	
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{    
	[authorizeViewController release];
    [tabBarController release];
    [window release];
	
    [super dealloc];
}

@end

