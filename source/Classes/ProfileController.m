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
	
	if (ticket.didSucceed)
	{
		NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSDictionary *dictionary = [responseBody yajl_JSON];
		[responseBody release];
		
		DLog(@"%@", dictionary);
		
		Profile *profile = [Profile profileWithDictionary:dictionary];
		
		[_delegate fetchProfileDidFinishWithResults:profile];
	}
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
