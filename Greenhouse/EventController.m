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
//  EventController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/31/10.
//

#import "EventController.h"
#import "OAuthManager.h"
#import "Event.h"


@implementation EventController

@synthesize delegate = _delegate;


#pragma mark -
#pragma mark Instance methods

- (void)fetchEvents
{
	NSURL *url = [[NSURL alloc] initWithString:EVENTS_URL];
	
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
													didFinishSelector:@selector(fetchEvents:didFinishWithData:)
													  didFailSelector:@selector(fetchEvents:didFailWithError:)];
	
	[_dataFetcher start];
	
	[request release];
}

- (void)fetchEvents:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	[_dataFetcher release];
	_dataFetcher = nil;
	
	NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	DLog(@"%@", responseBody);
	
	NSMutableArray *events = [[[NSMutableArray alloc] init] autorelease];
	
	if (ticket.didSucceed)
	{
		NSArray *jsonArray = [responseBody yajl_JSON];
		
		DLog(@"%@", jsonArray);
		
		for (NSDictionary *d in jsonArray)
		{
			Event *event = [[Event alloc] initWithDictionary:d];
			[events addObject:event];
			[event release];
		}
	}
	else 
	{
		[self request:ticket didNotSucceedWithDefaultMessage:@"A problem occurred while retrieving the event data."];
	}
	
	[responseBody release];
	
	if ([_delegate respondsToSelector:@selector(fetchEventsDidFinishWithResults:)])
	{
		[_delegate fetchEventsDidFinishWithResults:events];
	}
}

- (void)fetchEvents:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	[self request:ticket didFailWithError:error];
	
	if ([_delegate respondsToSelector:@selector(fetchEventsDidFailWithError:)])
	{
		[_delegate fetchEventsDidFailWithError:error];
	}
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc
{
	[super dealloc];
}

@end
