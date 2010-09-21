//
//  TwitterController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/27/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "TwitterController.h"
#import "OAuthManager.h"
#import "Tweet.h"


@implementation TwitterController

@synthesize delegate = _delegate;


#pragma mark -
#pragma mark Instance methods

- (void)fetchTweetsWithURL:(NSURL *)url
{
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url 
																   consumer:[OAuthManager sharedInstance].consumer
																	  token:[OAuthManager sharedInstance].accessToken
																	  realm:OAUTH_REALM
														  signatureProvider:nil]; // use the default method, HMAC-SHA1
	
	[request setHTTPMethod:@"GET"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	
	DLog(@"%@", request);
	
	[self cancelDataFetcherRequest];
	
	_dataFetcher = [[OAAsynchronousDataFetcher alloc] initWithRequest:request
															 delegate:self
													didFinishSelector:@selector(fetchTweets:didFinishWithData:)
													  didFailSelector:@selector(fetchTweets:didFailWithError:)];
	
	[_dataFetcher start];
	
	[request release];
}

- (void)fetchTweets:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{	
	[_dataFetcher release];
	_dataFetcher = nil;
	
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
		
		[_delegate fetchTweetsDidFinishWithResults:tweets];
	}	
}

- (void)fetchTweets:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	[self request:ticket didFailWithError:error didFailDelegate:_delegate didFailSelector:@selector(fetchTweetsDidFailWithError:)];
}

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
	
	[self cancelDataFetcherRequest];
	
	_dataFetcher = [[OAAsynchronousDataFetcher alloc] initWithRequest:request
															 delegate:self
													didFinishSelector:@selector(postUpdate:didFinishWithData:)
													  didFailSelector:@selector(postUpdate:didFailWithError:)];
	
	[_dataFetcher start];
	
	[request release];
}

- (void)postUpdate:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	[_dataFetcher release];
	_dataFetcher = nil;
	
	NSHTTPURLResponse *response = (NSHTTPURLResponse *)ticket.response;
	
	if (ticket.didSucceed)
	{
		DLog(@"%@", [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
		
		[_delegate postUpdateDidFinish];
	}
	else 
	{
		NSString *msg = nil;
		
		switch ([response statusCode]) 
		{
			case 412:
				msg = @"Your account is not connected to Twitter. Please sign in to greenhouse.springsource.org to connect.";
				break;
			case 403:
			default:
				msg = @"A problem occurred while posting to Twitter.";
				break;
		}
		
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil 
															message:msg 
														   delegate:nil 
												  cancelButtonTitle:@"OK" 
												  otherButtonTitles:nil];
		[alertView show];
		[alertView release];		
	}	
}

- (void)postUpdate:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	[self request:ticket didFailWithError:error didFailDelegate:_delegate didFailSelector:@selector(postUpdateDidFailWithError:)];
}

- (void)postRetweet:(NSString *)tweetId withURL:(NSURL *)url;
{
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url 
																   consumer:[OAuthManager sharedInstance].consumer
																	  token:[OAuthManager sharedInstance].accessToken
																	  realm:OAUTH_REALM
														  signatureProvider:nil]; // use the default method, HMAC-SHA1
	
	NSString *postParams =[[NSString alloc] initWithFormat:@"tweetId=%@", tweetId];
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
	
	[self cancelDataFetcherRequest];
	
	_dataFetcher = [[OAAsynchronousDataFetcher alloc] initWithRequest:request
															 delegate:self
													didFinishSelector:@selector(postRetweet:didFinishWithData:)
													  didFailSelector:@selector(postRetweet:didFailWithError:)];
	
	[_dataFetcher start];
	
	[request release];
}

- (void)postRetweet:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	[_dataFetcher release];
	_dataFetcher = nil;
	
	NSHTTPURLResponse *response = (NSHTTPURLResponse *)ticket.response;
	
	if (ticket.didSucceed)
	{		
		NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		DLog(@"%@", responseBody);
		[responseBody release];
		
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil 
															message:@"Retweet successful!" 
														   delegate:nil 
												  cancelButtonTitle:@"OK" 
												  otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		
		[_delegate postRetweetDidFinish];
	}
	else 
	{
		NSString *msg = nil;
		
		switch ([response statusCode]) 
		{
			case 412:
				msg = @"Your account is not connected to Twitter. Please sign in to greenhouse.springsource.org to connect.";
				break;
			case 403:
			default:
				msg = @"A problem occurred while posting to Twitter.";
				break;
		}
		
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil 
															message:msg 
														   delegate:nil 
												  cancelButtonTitle:@"OK" 
												  otherButtonTitles:nil];
		[alertView show];
		[alertView release];		
	}
}

- (void)postRetweet:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	[self request:ticket didFailWithError:error didFailDelegate:_delegate didFailSelector:@selector(postRetweetDidFailWithError:)];
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc
{
	[super dealloc];
}

@end
