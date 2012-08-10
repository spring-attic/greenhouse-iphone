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
//  GHEventController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/31/10.
//

#import "GHEventController.h"
#import "GHOAuthManager.h"
#import "GHEvent.h"


@implementation GHEventController

@synthesize delegate;


#pragma mark -
#pragma mark Instance methods

- (void)fetchEvents
{
	NSURL *url = [[NSURL alloc] initWithString:EVENTS_URL];
	
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url 
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
													didFinishSelector:@selector(fetchEvents:didFinishWithData:)
													  didFailSelector:@selector(fetchEvents:didFailWithError:)];
	
	[_dataFetcher start];
}

- (void)fetchEvents:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	_dataFetcher = nil;
	
	NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	DLog(@"%@", responseBody);
	
	NSMutableArray *events = [[NSMutableArray alloc] init];
	
	if (ticket.didSucceed)
	{
		NSArray *jsonArray = [responseBody yajl_JSON];
		
		DLog(@"%@", jsonArray);
		
		for (NSDictionary *d in jsonArray)
		{
			GHEvent *event = [[GHEvent alloc] initWithDictionary:d];
			[events addObject:event];
		}
	}
	else 
	{
		[self request:ticket didNotSucceedWithDefaultMessage:@"A problem occurred while retrieving the event data."];
	}
	
	if ([delegate respondsToSelector:@selector(fetchEventsDidFinishWithResults:)])
	{
		[delegate fetchEventsDidFinishWithResults:events];
	}
}

- (void)fetchEvents:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	[self request:ticket didFailWithError:error];
	
	if ([delegate respondsToSelector:@selector(fetchEventsDidFailWithError:)])
	{
		[delegate fetchEventsDidFailWithError:error];
	}
}

@end
