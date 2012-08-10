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
//  GHTwitterController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/27/10.
//

#import "GHTwitterController.h"
#import "GHOAuthManager.h"
#import "GHTweet.h"


@implementation GHTwitterController

@synthesize delegate;


#pragma mark -
#pragma mark Instance methods

- (void)fetchTweetsWithURL:(NSURL *)url page:(NSUInteger)page;
{
	NSString *urlString = [[NSString alloc] initWithFormat:@"%@?page=%d&pageSize=%d", [url absoluteString], page, TWITTER_PAGE_SIZE];
	
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]
																   consumer:[GHOAuthManager sharedInstance].consumer
																	  token:[GHOAuthManager sharedInstance].accessToken
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
}

- (void)fetchTweets:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	_dataFetcher = nil;
	
	NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	DLog(@"%@", responseBody);
	
	NSMutableArray *tweets = [[NSMutableArray alloc] init];
	BOOL lastPage = NO;
		
	if (ticket.didSucceed)
	{
		NSDictionary *dictionary = [responseBody yajl_JSON];
		
		DLog(@"%@", dictionary);
		
		lastPage = [dictionary boolForKey:@"lastPage"];
		
		NSArray *jsonArray = (NSArray *)[dictionary objectForKey:@"tweets"];
		
		for (NSDictionary *d in jsonArray) 
		{
			GHTweet *tweet = [[GHTweet alloc] initWithDictionary:d];
			[tweets addObject:tweet];
		}
	}
	else 
	{
		[self request:ticket didNotSucceedWithDefaultMessage:@"A problem occurred while retrieving the Twitter feed."];
	}

	if ([delegate respondsToSelector:@selector(fetchTweetsDidFinishWithResults:lastPage:)])
	{
		[delegate fetchTweetsDidFinishWithResults:tweets lastPage:lastPage];
	}
}

- (void)fetchTweets:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	[self request:ticket didFailWithError:error];
	
	if ([delegate respondsToSelector:@selector(fetchTweetsDidFailWithError:)])
	{
		[delegate fetchTweetsDidFailWithError:error];
	}
}

- (void)postUpdate:(NSString *)update withURL:(NSURL *)url
{
	CLLocation *location = [[CLLocation alloc] init];
	[self postUpdate:update withURL:url location:location];
}

- (void)postUpdate:(NSString *)update withURL:(NSURL *)url location:(CLLocation *)location
{
	self.activityAlertView = [[GHActivityAlertView alloc] initWithActivityMessage:@"Posting tweet..."];
	[_activityAlertView startAnimating];

    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url 
																   consumer:[GHOAuthManager sharedInstance].consumer
																	  token:[GHOAuthManager sharedInstance].accessToken
																	  realm:OAUTH_REALM
														  signatureProvider:nil]; // use the default method, HMAC-SHA1
	
	NSString *status = [update stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	DLog(@"tweet length: %i", status.length);
	
	status = [status URLEncodedString];
	
	NSString *postParams = [[NSString alloc] initWithFormat:@"status=%@&latitude=%f&longitude=%f", status, 
							location.coordinate.latitude, location.coordinate.longitude];
	DLog(@"%@", postParams);
	
	NSData *postData = [postParams dataUsingEncoding:NSUTF8StringEncoding];
	
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:postData];
	
	DLog(@"%@", request);
	
	[self cancelDataFetcherRequest];
	
	_dataFetcher = [[OAAsynchronousDataFetcher alloc] initWithRequest:request
															 delegate:self
													didFinishSelector:@selector(postUpdate:didFinishWithData:)
													  didFailSelector:@selector(postUpdate:didFailWithError:)];
	
	[_dataFetcher start];
}

- (void)postUpdate:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	_dataFetcher = nil;
	
	[_activityAlertView stopAnimating];
	self.activityAlertView = nil;
	
	NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	DLog(@"%@", responseBody);
	
	NSHTTPURLResponse *response = (NSHTTPURLResponse *)ticket.response;
	
	if (ticket.didSucceed)
	{
		if ([delegate respondsToSelector:@selector(postUpdateDidFinish)])
		{
			[delegate postUpdateDidFinish];
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
	}
}

- (void)postUpdate:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	[_activityAlertView stopAnimating];
	self.activityAlertView = nil;

	[self request:ticket didFailWithError:error];
	
	if ([delegate respondsToSelector:@selector(postUpdateDidFailWithError:)])
	{
		[delegate postUpdateDidFailWithError:error];
	}
}

- (void)postRetweet:(NSString *)tweetId withURL:(NSURL *)url;
{
	self.activityAlertView = [[GHActivityAlertView alloc] initWithActivityMessage:@"Posting tweet..."];
	[_activityAlertView startAnimating];
	
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url 
																   consumer:[GHOAuthManager sharedInstance].consumer
																	  token:[GHOAuthManager sharedInstance].accessToken
																	  realm:OAUTH_REALM
														  signatureProvider:nil]; // use the default method, HMAC-SHA1
	
	NSString *postParams =[[NSString alloc] initWithFormat:@"tweetId=%@", tweetId];
	DLog(@"%@", postParams);
	
	NSString *escapedPostParams = [postParams stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	DLog(@"%@", escapedPostParams);
	
	NSData *postData = [escapedPostParams dataUsingEncoding:NSUTF8StringEncoding];	
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:postData];
	DLog(@"%@", request);
	
	[self cancelDataFetcherRequest];
	
	_dataFetcher = [[OAAsynchronousDataFetcher alloc] initWithRequest:request
															 delegate:self
													didFinishSelector:@selector(postRetweet:didFinishWithData:)
													  didFailSelector:@selector(postRetweet:didFailWithError:)];
	
	[_dataFetcher start];
}

- (void)postRetweet:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	_dataFetcher = nil;
	
	[_activityAlertView stopAnimating];
	self.activityAlertView = nil;
	
	NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	DLog(@"%@", responseBody);
	
	NSHTTPURLResponse *response = (NSHTTPURLResponse *)ticket.response;
	
	if (ticket.didSucceed)
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil 
															message:@"Retweet successful!" 
														   delegate:nil 
												  cancelButtonTitle:@"OK" 
												  otherButtonTitles:nil];
		[alertView show];
		
		if ([delegate respondsToSelector:@selector(postRetweetDidFinish)])
		{
			[delegate postRetweetDidFinish];
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
	}
}

- (void)postRetweet:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	[_activityAlertView stopAnimating];
	self.activityAlertView = nil;

	[self request:ticket didFailWithError:error];
	
	if ([delegate respondsToSelector:@selector(postRetweetDidFailWithError:)])
	{
		[delegate postRetweetDidFailWithError:error];
	}	
}

@end
