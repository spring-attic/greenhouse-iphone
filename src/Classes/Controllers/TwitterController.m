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

- (void)fetchTweetsWithURL:(NSURL *)url page:(NSUInteger)page;
{
	NSString *urlString = [[NSString alloc] initWithFormat:@"%@?page=%d&pageSize=%d", [url absoluteString], page, TWITTER_PAGE_SIZE];
	
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]
																   consumer:[OAuthManager sharedInstance].consumer
																	  token:[OAuthManager sharedInstance].accessToken
																	  realm:OAUTH_REALM
														  signatureProvider:nil]; // use the default method, HMAC-SHA1
	[urlString release];
	
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
	
	NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	DLog(@"%@", responseBody);
	
	NSMutableArray *tweets = [[[NSMutableArray alloc] init] autorelease];
	BOOL lastPage = NO;
		
	if (ticket.didSucceed)
	{
		NSDictionary *dictionary = [responseBody yajl_JSON];
		
		DLog(@"%@", dictionary);
		
		lastPage = [dictionary boolForKey:@"lastPage"];
		
		NSArray *jsonArray = (NSArray *)[dictionary objectForKey:@"tweets"];
		
		for (NSDictionary *d in jsonArray) 
		{
			Tweet *tweet = [[Tweet alloc] initWithDictionary:d];
			[tweets addObject:tweet];
			[tweet release];
		}
	}
	else 
	{
		[self request:ticket didNotSucceedWithDefaultMessage:@"A problem occurred while retrieving the Twitter feed."];
	}
	
	[responseBody release];
	
	if ([_delegate respondsToSelector:@selector(fetchTweetsDidFinishWithResults:lastPage:)])
	{
		[_delegate fetchTweetsDidFinishWithResults:tweets lastPage:lastPage];
	}
}

- (void)fetchTweets:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	[self request:ticket didFailWithError:error];
	
	if ([_delegate respondsToSelector:@selector(fetchTweetsDidFailWithError:)])
	{
		[_delegate fetchTweetsDidFailWithError:error];
	}
}

- (void)postUpdate:(NSString *)update withURL:(NSURL *)url
{
	CLLocation *location = [[[CLLocation alloc] init] autorelease];
	[self postUpdate:update withURL:url location:location];
}

- (void)postUpdate:(NSString *)update withURL:(NSURL *)url location:(CLLocation *)location
{
	self.activityAlertiView = [[ActivityAlertView alloc] initWithActivityMessage:@"Posting tweet..."];
	[_activityAlertiView startAnimating];

    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url 
																   consumer:[OAuthManager sharedInstance].consumer
																	  token:[OAuthManager sharedInstance].accessToken
																	  realm:OAUTH_REALM
														  signatureProvider:nil]; // use the default method, HMAC-SHA1
	
	NSString *status = [update stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	DLog(@"tweet length: %i", status.length);
	
	status = [status URLEncodedString];
	
	NSString *postParams = [[NSString alloc] initWithFormat:@"status=%@&latitude=%f&longitude=%f", status, 
							location.coordinate.latitude, location.coordinate.longitude];
	DLog(@"%@", postParams);
	
	NSData *postData = [[postParams dataUsingEncoding:NSUTF8StringEncoding] retain];
	[postParams release];
	
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
	
	[_activityAlertiView stopAnimating];
	self.activityAlertiView = nil;
	
	NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	DLog(@"%@", responseBody);
	
	[responseBody release];
	
	NSHTTPURLResponse *response = (NSHTTPURLResponse *)ticket.response;
	
	if (ticket.didSucceed)
	{
		if ([_delegate respondsToSelector:@selector(postUpdateDidFinish)])
		{
			[_delegate postUpdateDidFinish];
		}
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
	[_activityAlertiView stopAnimating];
	self.activityAlertiView = nil;

	[self request:ticket didFailWithError:error];
	
	if ([_delegate respondsToSelector:@selector(postUpdateDidFailWithError:)])
	{
		[_delegate postUpdateDidFailWithError:error];
	}
}

- (void)postRetweet:(NSString *)tweetId withURL:(NSURL *)url;
{
	self.activityAlertiView = [[ActivityAlertView alloc] initWithActivityMessage:@"Posting tweet..."];
	[_activityAlertiView startAnimating];
	
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
	
	[_activityAlertiView stopAnimating];
	self.activityAlertiView = nil;
	
	NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

	DLog(@"%@", responseBody);
	
	[responseBody release];
	
	NSHTTPURLResponse *response = (NSHTTPURLResponse *)ticket.response;
	
	if (ticket.didSucceed)
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil 
															message:@"Retweet successful!" 
														   delegate:nil 
												  cancelButtonTitle:@"OK" 
												  otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		
		if ([_delegate respondsToSelector:@selector(postRetweetDidFinish)])
		{
			[_delegate postRetweetDidFinish];
		}
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
	[_activityAlertiView stopAnimating];
	self.activityAlertiView = nil;

	[self request:ticket didFailWithError:error];
	
	if ([_delegate respondsToSelector:@selector(postRetweetDidFailWithError:)])
	{
		[_delegate postRetweetDidFailWithError:error];
	}	
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc
{
	[super dealloc];
}

@end
