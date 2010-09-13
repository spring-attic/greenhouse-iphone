//
//  EventController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/31/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "EventController.h"
#import "Event.h"


@implementation EventController

@synthesize delegate;

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
	if (self.fetchingData == YES)
	{
		return;
	}
	
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
	
	[self.dataFetcher fetchDataWithRequest:request
								  delegate:self
						 didFinishSelector:@selector(fetchEvents:didFinishWithData:)
						   didFailSelector:@selector(fetchEvents:didFailWithError:)];
	
	[request release];
	
	self.fetchingData = YES;
}

- (void)fetchEvents:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	self.fetchingData = NO;
	
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
		
		[delegate fetchEventsDidFinishWithResults:events];
	}
}

- (void)fetchEvents:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
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
