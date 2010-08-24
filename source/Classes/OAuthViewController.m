    //
//  OAuthViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/16/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

// This class is meant to function as an abstract class. See the following link
// for more information on encouraging overriding of methods in a subclass
// http://developer.apple.com/mac/library/documentation/Cocoa/Reference/Foundation/Classes/NSObject_Class/Reference/Reference.html#//apple_ref/doc/uid/20000050-doesNotRecognizeSelector_


#import "OAuthViewController.h"
#import "OAuthManager.h"


@implementation OAuthViewController

@synthesize fetchingData;

- (void)fetchJSONDataWithURL:(NSURL *)url
{	
	fetchingData = YES;
	
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url 
																   consumer:[OAuthManager sharedInstance].consumer
																	  token:[OAuthManager sharedInstance].accessToken
																	  realm:OAUTH_REALM
														  signatureProvider:nil]; // use the default method, HMAC-SHA1
	
	[request setHTTPMethod:@"GET"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	
	DLog(@"%@", request);
	
	OADataFetcher *fetcher = [[OADataFetcher alloc] init];
	
	[fetcher fetchDataWithRequest:request
						 delegate:self
				didFinishSelector:@selector(fetchRequest:didFinishWithData:)
				  didFailSelector:@selector(fetchRequest:didFailWithError:)];
	
	[request release];
}

- (void)fetchRequest:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{	
	// throws exception if this method is not overridden by a subclass
	[self doesNotRecognizeSelector:_cmd];
}

- (void)fetchRequest:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	DLog(@"%@", [error localizedDescription]);
	
	if ([error code] == NSURLErrorUserCancelledAuthentication)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
														message:@"You are not authorized to view the content from greenhouse.com. Please sign out and reauthorize the app." 
													   delegate:self 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:@"Sign Out", nil];
		[alert show];
		[alert release];
	}
	else 
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
														message:@"An error occurred while connecting to the server." 
													   delegate:nil 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
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
		[appDelegate showAuthorizeViewController];
	}
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
    [super dealloc];
}


@end
