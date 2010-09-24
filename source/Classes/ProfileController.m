//
//  ProfileController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 9/7/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "ProfileController.h"
#import "Profile.h"
#import "OAuthManager.h"


@implementation ProfileController

@synthesize delegate = _delegate;


#pragma mark -
#pragma mark Instance methods

- (void)fetchProfile
{
	NSURL *url = [[NSURL alloc] initWithString:MEMBER_PROFILE_URL];
	
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
																   consumer:[OAuthManager sharedInstance].consumer
																	  token:[OAuthManager sharedInstance].accessToken
																	  realm:OAUTH_REALM
														  signatureProvider:nil]; // use the default method, HMAC-SHA1
	
	[url release];
	
	[request setHTTPMethod:@"GET"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	
	DLog(@"%@", request);
	
	[self cancelDataFetcherRequest];
	
	_dataFetcher = [[OAAsynchronousDataFetcher alloc] initWithRequest:request
															 delegate:self
													didFinishSelector:@selector(fetchProfile:didFinishWithData:)
													  didFailSelector:@selector(fetchProfile:didFailWithError:)];
	[_dataFetcher start];
	
	[request release];
}

- (void)fetchProfile:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	[_dataFetcher release];
	_dataFetcher = nil;
	
	NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	DLog(@"%@", responseBody);
	
	Profile *profile = nil;
	
	if (ticket.didSucceed)
	{
		NSDictionary *dictionary = [responseBody yajl_JSON];
		
		DLog(@"%@", dictionary);
		
		profile = [Profile profileWithDictionary:dictionary];
	}
	else 
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
														message:@"A problem occurred while retrieving the profile data." 
													   delegate:nil 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
	[responseBody release];
	
	[_delegate fetchProfileDidFinishWithResults:profile];
}

- (void)fetchProfile:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	[self request:ticket didFailWithError:error didFailDelegate:_delegate didFailSelector:@selector(fetchProfileDidFailWithError:)];
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc
{
	[super dealloc];
}

@end
