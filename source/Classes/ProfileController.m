//
//  ProfileController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 9/7/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "ProfileController.h"
#import "Profile.h"


@implementation ProfileController

@synthesize delegate;

#pragma mark -
#pragma mark Static methods

+ (ProfileController *)profileController
{
	return [[[ProfileController alloc] init] autorelease];
}


#pragma mark -
#pragma mark Instance methods

- (void)fetchProfile
{
	if (self.fetchingData == YES)
	{
		return;
	}
	
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
	
	[self.dataFetcher fetchDataWithRequest:request
								  delegate:self
						 didFinishSelector:@selector(fetchProfile:didFinishWithData:)
						   didFailSelector:@selector(fetchProfile:didFailWithError:)];
	
	[request release];
	
	self.fetchingData = YES;
}

- (void)fetchProfile:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	self.fetchingData = NO;
	
	if (ticket.didSucceed)
	{
		NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSDictionary *dictionary = [responseBody yajl_JSON];
		[responseBody release];
		
		DLog(@"%@", dictionary);
		
		Profile *profile = [Profile profileWithDictionary:dictionary];
		
		[delegate fetchProfileDidFinishWithResults:profile];
	}
}

- (void)fetchProfile:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	self.fetchingData = NO;
	
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
#pragma mark NSObject methods

- (void)dealloc
{
	[super dealloc];
}

@end
