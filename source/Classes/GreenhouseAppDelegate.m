//
//  GreenhouseAppDelegate.m
//  Greenhouse
//
//  Created by Roy Clarkson on 6/7/10.
//  Copyright VMware, Inc. 2010. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "GreenhouseAppDelegate.h"
#import "MainViewController.h"
#import "AuthorizeViewController.h"
#import "OAuthManager.h"


@implementation GreenhouseAppDelegate

@synthesize window;
@synthesize mainViewController;
@synthesize authorizeViewController;

- (void)showAuthorizeViewController
{	
	if (mainViewController)
	{
		[mainViewController.view removeFromSuperview];
		[mainViewController release];
	}
	
	self.authorizeViewController = [[AuthorizeViewController alloc] initWithNibName:nil bundle:nil];
	[window addSubview:authorizeViewController.view];		
}

- (void)showMainViewController
{
	if (authorizeViewController)
	{
		[authorizeViewController.view removeFromSuperview];
		[authorizeViewController release];
	}

	self.mainViewController = [[MainViewController alloc] initWithNibName:nil bundle:nil];
	[window addSubview:mainViewController.view];
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
				didFinishSelector:@selector(showMainViewController)
				  didFailSelector:@selector(showAuthorizeViewController)];
	}

	return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	if (launchOptions)
	{
		NSURL *url = (NSURL *)[launchOptions objectForKey:@"UIApplicationLaunchOptionsURLKey"];
		
		if (url)
		{
			OAuthManager *mgr = [OAuthManager sharedInstance];
			[mgr processOauthResponse:url 
							 delegate:self 
					didFinishSelector:@selector(showMainViewController)
					  didFailSelector:@selector(showAuthorizeViewController)];
		}
		else
		{
			[self showAuthorizeViewController];
		}
	}
	else if ([[OAuthManager sharedInstance] isAuthorized])
	{
		[self showMainViewController];
	}
	else 
	{
		[self showAuthorizeViewController];
	}
	
    [window makeKeyAndVisible];
	
    CLLocationManager *manager = [[CLLocationManager alloc] init];
	
    if (manager.locationServicesEnabled == NO) 
	{
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" 
																		message:@"Greenhouse would like to use your current location but you currently have all location services disabled. If you proceed, you will be asked to confirm whether location services should be reenabled." 
																	   delegate:nil 
															  cancelButtonTitle:@"OK" 
															  otherButtonTitles:nil];
        [servicesDisabledAlert show];
        [servicesDisabledAlert release];
    }
    [manager release];
	
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
    [mainViewController release];
    [window release];
	
    [super dealloc];
}

@end

