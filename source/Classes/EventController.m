//
//  EventController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/31/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "EventController.h"
#import "OAuthManager.h"
#import "Event.h"


@implementation EventController

@synthesize delegate = _delegate;

#pragma mark -
#pragma mark Static methods

+ (EventController *)eventController
{
	return [[[EventController alloc] init] autorelease];
}


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
	
	_dataFetcher = [[OADataFetcher alloc] init];
	
	[_dataFetcher fetchDataWithRequest:request
							  delegate:self
					 didFinishSelector:@selector(fetchEvents:didFinishWithData:)
					   didFailSelector:@selector(fetchEvents:didFailWithError:)];
	
	[request release];
}

- (void)fetchEvents:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	[_dataFetcher release];
	
	if (ticket.didSucceed)
	{
		NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSArray *jsonArray = [responseBody yajl_JSON];
		[responseBody release];
		
		DLog(@"%@", jsonArray);
		
		NSMutableArray *events = [NSMutableArray arrayWithCapacity:[jsonArray count]];
		
		for (NSDictionary *d in jsonArray)
		{
			Event *event = [[Event alloc] initWithDictionary:d];
			[events addObject:event];
			[event release];
		}
		
		[_delegate fetchEventsDidFinishWithResults:events];
	}
}

- (void)fetchEvents:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	[self request:ticket didFailWithError:error didFailDelegate:_delegate didFailSelector:@selector(fetchEventsDidFailWithError:)];
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc
{
	[super dealloc];
}

@end
