//
//  TwitterController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/27/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "TwitterController.h"
#import "Tweet.h"


@implementation TwitterController

@synthesize delegate;


#pragma mark -
#pragma mark Static methods

+ (TwitterController *)twitterController
{
	return [[[TwitterController alloc] init] autorelease];
}


#pragma mark -
#pragma mark Instance methods

- (void)fetchTweetsWithURL:(NSURL *)url
{
	if (self.fetchingData == YES)
	{
		return;
	}
	
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url 
																   consumer:[OAuthManager sharedInstance].consumer
																	  token:[OAuthManager sharedInstance].accessToken
																	  realm:OAUTH_REALM
														  signatureProvider:nil]; // use the default method, HMAC-SHA1
	
	[request setHTTPMethod:@"GET"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	
	DLog(@"%@", request);
	
	[self.dataFetcher fetchDataWithRequest:request
								  delegate:self
						 didFinishSelector:@selector(fetchTweets:didFinishWithData:)
						   didFailSelector:@selector(fetchTweets:didFailWithError:)];
	
	[request release];
}

- (void)fetchTweets:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{	
	self.fetchingData = NO;
	
	if (ticket.didSucceed)
	{
		NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSDictionary *dictionary = [responseBody yajl_JSON];
		[responseBody release];
		
		DLog(@"%@", dictionary);
		
		NSArray *jsonArray = (NSArray *)[dictionary objectForKey:@"tweets"];
		NSMutableArray *tweets = [NSMutableArray arrayWithCapacity:[jsonArray count]];
		
		for (NSDictionary *d in jsonArray) 
		{
			Tweet *tweet = [[Tweet alloc] initWithDictionary:d];
			[tweets addObject:tweet];
			[tweet release];
		}
		
		[delegate fetchTweetsDidFinishWithResults:tweets];
	}	
}

- (void)fetchTweets:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
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

//- (void)postEventUpdate:(NSString *)update
//{
//	CLLocation *location = [[[CLLocation alloc] init] autorelease];
//	[self postEventUpdate:update withLocation:location];
//}
//
//- (void)postEventUpdate:(NSString *)update withLocation:(CLLocation *)location
//{
//	[self postUpdate:update withURL:[NSURL URLWithString:EVENT_TWEETS_URL] location:location];
//}
//
//- (void)postEventSessionUpdate:(NSString *)update
//{
//	CLLocation *location = [[[CLLocation alloc] init] autorelease];
//	[self postEventSessionUpdate:update withLocation:location];
//}
//
//- (void)postEventSessionUpdate:(NSString *)update withLocation:(CLLocation *)location
//{
//	[self postUpdate:update withURL:[NSURL URLWithString:EVENT_SESSION_TWEETS_URL] location:location];
//}

- (void)postUpdate:(NSString *)update withURL:(NSURL *)url
{
	CLLocation *location = [[[CLLocation alloc] init] autorelease];
	[self postUpdate:update withURL:url location:location];
}

- (void)postUpdate:(NSString *)update withURL:(NSURL *)url location:(CLLocation *)location
{
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url 
																   consumer:[OAuthManager sharedInstance].consumer
																	  token:[OAuthManager sharedInstance].accessToken
																	  realm:OAUTH_REALM
														  signatureProvider:nil]; // use the default method, HMAC-SHA1
	
	NSString *s = [update stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	DLog(@"tweet length: %i", s.length);
	
	NSString *postParams =[[NSString alloc] initWithFormat:@"status=%@&latitude=%f&longitude=%f", s, 
						   location.coordinate.latitude, location.coordinate.longitude];
	DLog(@"%@", postParams);
	
	NSString *escapedPostParams = [[postParams stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] retain];
	[postParams release];
	DLog(@"%@", escapedPostParams);
	
	NSData *postData = [[escapedPostParams dataUsingEncoding:NSUTF8StringEncoding] retain];
	[escapedPostParams release];
	
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:postData];
	[postData release];
	
	DLog(@"%@", request);
	
	[self.dataFetcher fetchDataWithRequest:request
								  delegate:self
						 didFinishSelector:@selector(postUpdate:didFinishWithData:)
						   didFailSelector:@selector(postUpdate:didFailWithError:)];
	
	[request release];
}

- (void)postUpdate:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	self.fetchingData = NO;
	
	NSHTTPURLResponse *response = (NSHTTPURLResponse *)ticket.response;
	
	if (ticket.didSucceed)
	{
		DLog(@"%@", [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
		
		[delegate postUpdateDidFinish];
	}
	else if ([response statusCode] == 412)
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil 
															message:@"Your account is not connected to Twitter. Please sign in to greenhouse.springsource.org to connect." 
														   delegate:nil 
												  cancelButtonTitle:@"OK" 
												  otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
}

- (void)postUpdate:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
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
	
	[delegate postUpdateDidFailWithError:error];
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc
{
	[super dealloc];
}

@end
