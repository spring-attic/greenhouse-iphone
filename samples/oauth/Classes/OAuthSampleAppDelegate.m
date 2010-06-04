//
//  OAuthSampleAppDelegate.m
//  OAuthSample
//
//  Created by Roy Clarkson on 5/27/10.
//  Copyright VMware 2010. All rights reserved.
//

#import "OAuthSampleAppDelegate.h"
#import "OAuthSampleViewController.h"
#import "OAuthManager.h"


@implementation OAuthSampleAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;


#pragma mark -
#pragma mark UIApplicationDelegate methods
#pragma mark

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
    [_window addSubview:_viewController.view];
    [_window makeKeyAndVisible];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url 
{
	[[OAuthManager sharedInstance] processOauthResponse:url];
	
	return YES;
}


#pragma mark -
#pragma mark NSObject methods
#pragma mark

- (void)dealloc 
{
    [_viewController release];
    [_window release];
	
    [super dealloc];
}


@end
