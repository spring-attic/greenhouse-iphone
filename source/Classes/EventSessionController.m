//
//  EventSessionController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 9/7/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "EventSessionController.h"
#import "EventSession.h"


@implementation EventSessionController

@synthesize delegate;

#pragma mark -
#pragma mark Static methods

+ (EventSessionController *)eventSessionController
{
	return [[[EventSessionController alloc] init] autorelease];
}


#pragma mark -
#pragma mark Instance methods

- (void)fetchCurrentSessionsByEventId:(NSString *)eventId;
{
	if (self.fetchingData == YES)
	{
		return;
	}
	
	NSString *urlString = [[NSString alloc] initWithFormat:EVENT_SESSIONS_CURRENT_URL, eventId];
	NSURL *url = [[NSURL alloc] initWithString:urlString];
	[urlString release];
	
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
						 didFinishSelector:@selector(fetchCurrentSessions:didFinishWithData:)
						   didFailSelector:@selector(fetchCurrentSessions:didFailWithError:)];
	
	[request release];
	
	self.fetchingData = YES;
}

- (void)fetchCurrentSessions:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	self.fetchingData = NO;
	
	if (ticket.didSucceed)
	{
		NSMutableArray *arrayCurrentSessions = [[[NSMutableArray alloc] init] autorelease];
		NSMutableArray *arrayUpcomingSessions = [[[NSMutableArray alloc] init] autorelease];
		
		NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSArray *jsonArray = [responseBody yajl_JSON];
		[responseBody release];
		
		DLog(@"%@", jsonArray);
		
		NSDate *nextStartTime = nil;
		
		for (NSDictionary *d in jsonArray) 
		{
			EventSession *session = [[EventSession alloc] initWithDictionary:d];
			
			NSDate *now = [NSDate date];
			
			if ([now compare:session.startTime] == NSOrderedDescending &&
				[now compare:session.endTime] == NSOrderedAscending)
			{
				// find the sessions that are happening now
				[arrayCurrentSessions addObject:session];
			}
			else if ([now compare:session.startTime] == NSOrderedAscending)
			{
				// determine the start time of the next block of sessions
				if (nextStartTime == nil)
				{
					nextStartTime = session.startTime;
				}
				
				if ([nextStartTime compare:session.startTime] == NSOrderedSame)
				{
					// only show the sessions occurring in the next block
					[arrayUpcomingSessions addObject:session];
				}
			}
			
			[session release];
		}
		
		[delegate fetchCurrentSessionsDidFinishWithResults:arrayCurrentSessions upcomingSessions:arrayUpcomingSessions];
	}	
}

- (void)fetchCurrentSessions:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
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

- (void)fetchSessionsByEventId:(NSString *)eventId withDate:(NSDate *)eventDate;
{
	if (self.fetchingData == YES)
	{
		return;
	}
	
	// request the sessions for the selected day
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"YYYY-MM-d"];
	NSString *dateString = [dateFormatter stringFromDate:eventDate];
	[dateFormatter release];
	NSString *urlString = [[NSString alloc] initWithFormat:EVENT_SESSIONS_BY_DAY_URL, eventId, dateString];
	NSURL *url = [[NSURL alloc] initWithString:urlString];
	[urlString release];
		
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
						 didFinishSelector:@selector(fetchSessions:didFinishWithData:)
						   didFailSelector:@selector(fetchSessions:didFailWithError:)];
	
	[request release];
	
	self.fetchingData = YES;
}

- (void)fetchSessions:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	self.fetchingData = NO;
	
	if (ticket.didSucceed)
	{
		NSMutableArray *arraySessions = [[[NSMutableArray alloc] init] autorelease];
		NSMutableArray *arrayTimes = [[[NSMutableArray alloc] init] autorelease];
		
		NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSArray *array = [responseBody yajl_JSON];
		[responseBody release];
		
		DLog(@"%@", array);
		
		NSMutableArray *arrayBlock = nil;
		NSDate *sessionTime = [NSDate distantPast];
		
		for (NSDictionary *d in array) 
		{
			EventSession *session = [[EventSession alloc] initWithDictionary:d];
			
			// for each time block create an array to hold the sessions for that block
			if ([sessionTime compare:session.startTime] == NSOrderedAscending)
			{
				arrayBlock = [[NSMutableArray alloc] init];
				[arraySessions addObject:arrayBlock];
				[arrayBlock release];
				
				[arrayBlock addObject:session];
			}
			else if ([sessionTime compare:session.startTime] == NSOrderedSame)
			{
				[arrayBlock addObject:session];
			}
			
			sessionTime = session.startTime;
			
			NSDate *date = [session.startTime copyWithZone:NULL];
			[arrayTimes addObject:date];
			[date release];
			
			[session release];
		}
		
		[delegate fetchSessionsByDateDidFinishWithResults:arraySessions andTimes:arrayTimes];
	}	
}

- (void)fetchSessions:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
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

- (void)fetchFavoriteSessionsByEventId:(NSString *)eventId
{
	if (self.fetchingData == YES)
	{
		return;
	}
	
	NSString *urlString = [[NSString alloc] initWithFormat:EVENT_SESSIONS_FAVORITES_URL, eventId];
	NSURL *url = [[NSURL alloc] initWithString:urlString];
	[urlString release];
	
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
						 didFinishSelector:@selector(fetchFavoriteSessions:didFinishWithData:)
						   didFailSelector:@selector(fetchFavoriteSessions:didFailWithError:)];
	
	[request release];
	
	self.fetchingData = YES;
}

- (void)fetchFavoriteSessions:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	self.fetchingData = NO;
	
	if (ticket.didSucceed)
	{
		NSMutableArray *arraySessions = [[[NSMutableArray alloc] init] autorelease];
		
		NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSArray *array = [responseBody yajl_JSON];
		[responseBody release];
		
		DLog(@"%@", array);
		
		for (NSDictionary *d in array) 
		{
			EventSession *session = [[EventSession alloc] initWithDictionary:d];
			[arraySessions addObject:session];			
			[session release];
		}
		
		[delegate fetchFavoriteSessionsDidFinishWithResults:arraySessions];
	}	
}

- (void)fetchFavoriteSessions:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
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

- (void)fetchConferenceFavoriteSessionsByEventId:(NSString *)eventId
{
	if (self.fetchingData == YES)
	{
		return;
	}
	
	NSString *urlString = [[NSString alloc] initWithFormat:EVENT_SESSIONS_CONFERENCE_FAVORITES_URL, eventId];
	NSURL *url = [[NSURL alloc] initWithString:urlString];
	[urlString release];
	
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
						 didFinishSelector:@selector(fetchConferenceFavoriteSessions:didFinishWithData:)
						   didFailSelector:@selector(fetchConferenceFavoriteSessions:didFailWithError:)];
	
	[request release];
	
	self.fetchingData = YES;
}

- (void)fetchConferenceFavoriteSessions:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	self.fetchingData = NO;
	
	if (ticket.didSucceed)
	{
		NSMutableArray *arraySessions = [[[NSMutableArray alloc] init] autorelease];
		
		NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSArray *array = [responseBody yajl_JSON];
		[responseBody release];
		
		DLog(@"%@", array);
		
		for (NSDictionary *d in array) 
		{
			EventSession *session = [[EventSession alloc] initWithDictionary:d];
			[arraySessions addObject:session];			
			[session release];
		}
		
		[delegate fetchConferenceFavoriteSessionsDidFinishWithResults:arraySessions];
	}	
}

- (void)fetchConferenceFavoriteSessions:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
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
