//
//  OAuthControllerBase.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/27/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "OAuthControllerBase.h"


@implementation OAuthControllerBase

@synthesize dataFetcher;
@synthesize fetchingData;

- (id)init
{
	if ((self = [super init]))
	{
		self.dataFetcher = [[OADataFetcher alloc] init];
	}
	
	return self;
}


#pragma mark -
#pragma mark UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1)
	{
		// sign out
		[[OAuthManager sharedInstance] removeAccessToken];
		[appDelegate showAuthorizeViewController];
	}
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc
{
	[dataFetcher release];
	
	[super dealloc];
}

@end
