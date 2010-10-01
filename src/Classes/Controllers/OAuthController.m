//
//  OAuthController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 9/16/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "OAuthController.h"
#import "OAuthManager.h"


@implementation OAuthController

@synthesize activityAlertiView = _activityAlertiView;

- (void)cancelDataFetcherRequest
{
	if (_dataFetcher)
	{
		DLog(@"");
		
		[_dataFetcher cancel];
		[_dataFetcher release];
		_dataFetcher = nil;
	}
}

- (void)request:(OAServiceTicket *)ticket didNotSucceedWithDefaultMessage:(NSString *)message
{
	NSHTTPURLResponse *response = (NSHTTPURLResponse *)ticket.response;
	NSInteger statusCode = [response statusCode];

	DLog(@"status code: %d", statusCode);
	
	if (statusCode == 401)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
														message:@"You are not authorized to view the content from greenhouse.springsource.com. Please sign out and reauthorize the Greenhouse app." 
													   delegate:appDelegate 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:@"Sign Out", nil];
		[alert show];
		[alert release];
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
														message:message 
													   delegate:nil 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

- (void)request:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	[_dataFetcher release];
	_dataFetcher = nil;
	
	DLog(@"%@", [error localizedDescription]);
	
	if ([error code] == NSURLErrorUserCancelledAuthentication)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
														message:@"You are not authorized to view the content from greenhouse.springsource.com. Please sign out and reauthorize the Greenhouse app." 
													   delegate:appDelegate 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:@"Sign Out", nil];
		[alert show];
		[alert release];
	}
	else 
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
														message:@"The network connection is not available. Please try again in a few minutes." 
													   delegate:nil 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}	
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc
{
	[self cancelDataFetcherRequest];
	[_activityAlertiView release];
	
	[super dealloc];
}

@end
