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
//  ProfileController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 9/7/10.
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
		[self request:ticket didNotSucceedWithDefaultMessage:@"A problem occurred while retrieving the profile data."];
	}
	
	[responseBody release];
	
	if ([_delegate respondsToSelector:@selector(fetchProfileDidFinishWithResults:)])
	{
		[_delegate fetchProfileDidFinishWithResults:profile];
	}
}

- (void)fetchProfile:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	[self request:ticket didFailWithError:error];
	
	if ([_delegate respondsToSelector:@selector(fetchProfileDidFailWithError:)])
	{
		[_delegate fetchProfileDidFailWithError:error];
	}
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc
{
	[super dealloc];
}

@end
