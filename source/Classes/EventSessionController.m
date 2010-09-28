//
//  EventSessionController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 9/7/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "EventSessionController.h"
#import "EventSession.h"
#import "OAuthManager.h"


static BOOL sharedShouldRefreshFavorites;

@implementation EventSessionController

@synthesize delegate = _delegate;

#pragma mark -
#pragma mark Static methods

+ (BOOL)shouldRefreshFavorites
{	
    return sharedShouldRefreshFavorites;
}


#pragma mark -
#pragma mark Instance methods

- (void)fetchCurrentSessionsByEventId:(NSString *)eventId;
{
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
	
	[self cancelDataFetcherRequest];
	
	_dataFetcher = [[OAAsynchronousDataFetcher alloc] initWithRequest:request
															 delegate:self
													didFinishSelector:@selector(fetchCurrentSessions:didFinishWithData:)
													  didFailSelector:@selector(fetchCurrentSessions:didFailWithError:)];
	
	[_dataFetcher start];
	
	[request release];
}

- (void)fetchCurrentSessions:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	[_dataFetcher release];
	_dataFetcher = nil;
	
	NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	DLog(@"%@", responseBody);
	
	NSMutableArray *arrayCurrentSessions = [[[NSMutableArray alloc] init] autorelease];
	NSMutableArray *arrayUpcomingSessions = [[[NSMutableArray alloc] init] autorelease];
	
	if (ticket.didSucceed)
	{		
		NSArray *jsonArray = [responseBody yajl_JSON];
		
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
	}
	else 
	{
		[self request:ticket didNotSucceedWithDefaultMessage:@"A problem occurred while retrieving the session data."];
	}	
	
	[responseBody release];

	if ([_delegate respondsToSelector:@selector(fetchCurrentSessionsDidFinishWithResults:upcomingSessions:)])
	{
		[_delegate fetchCurrentSessionsDidFinishWithResults:arrayCurrentSessions upcomingSessions:arrayUpcomingSessions];
	}
}

- (void)fetchCurrentSessions:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	[self request:ticket didFailWithError:error];
	
	if ([_delegate respondsToSelector:@selector(fetchCurrentSessionsDidFailWithError:)])
	{
		[_delegate fetchCurrentSessionsDidFailWithError:error];
	}	
}

- (void)fetchSessionsByEventId:(NSString *)eventId withDate:(NSDate *)eventDate;
{
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
	
	[self cancelDataFetcherRequest];
	
	_dataFetcher = [[OAAsynchronousDataFetcher alloc] initWithRequest:request
															 delegate:self
													didFinishSelector:@selector(fetchSessions:didFinishWithData:)
													  didFailSelector:@selector(fetchSessions:didFailWithError:)];
	
	[_dataFetcher start];
	
	[request release];
}

- (void)fetchSessions:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	[_dataFetcher release];
	_dataFetcher = nil;
	
	NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	DLog(@"%@", responseBody);

	NSMutableArray *arraySessions = [[[NSMutableArray alloc] init] autorelease];
	NSMutableArray *arrayTimes = [[[NSMutableArray alloc] init] autorelease];
		
	if (ticket.didSucceed)
	{
		NSArray *array = [responseBody yajl_JSON];
		
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
	}
	else 
	{
		[self request:ticket didNotSucceedWithDefaultMessage:@"A problem occurred while retrieving the session data."];
	}
	
	[responseBody release];

	if ([_delegate respondsToSelector:@selector(fetchSessionsByDateDidFinishWithResults:andTimes:)])
	{
		[_delegate fetchSessionsByDateDidFinishWithResults:arraySessions andTimes:arrayTimes];
	}
}

- (void)fetchSessions:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	[self request:ticket didFailWithError:error];
	
	if ([_delegate respondsToSelector:@selector(fetchSessionsByDateDidFailWithError:)])
	{
		[_delegate fetchSessionsByDateDidFailWithError:error];
	}
}

- (void)fetchFavoriteSessionsByEventId:(NSString *)eventId
{
	sharedShouldRefreshFavorites = NO;
	
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
	
	[self cancelDataFetcherRequest];
	
	_dataFetcher = [[OAAsynchronousDataFetcher alloc] initWithRequest:request
															 delegate:self
													didFinishSelector:@selector(fetchFavoriteSessions:didFinishWithData:)
													  didFailSelector:@selector(fetchFavoriteSessions:didFailWithError:)];
	
	[_dataFetcher start];
	
	[request release];
}

- (void)fetchFavoriteSessions:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	[_dataFetcher release];
	_dataFetcher = nil;
	
	NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

	DLog(@"%@", responseBody);
	
	NSMutableArray *arraySessions = [[[NSMutableArray alloc] init] autorelease];
	
	if (ticket.didSucceed)
	{
		NSArray *array = [responseBody yajl_JSON];
		
		DLog(@"%@", array);
		
		for (NSDictionary *d in array) 
		{
			EventSession *session = [[EventSession alloc] initWithDictionary:d];
			[arraySessions addObject:session];			
			[session release];
		}
	}
	else 
	{
		[self request:ticket didNotSucceedWithDefaultMessage:@"A problem occurred while retrieving the session data."];
	}
	
	[responseBody release];

	if ([_delegate respondsToSelector:@selector(fetchFavoriteSessionsDidFinishWithResults:)])
	{
		[_delegate fetchFavoriteSessionsDidFinishWithResults:arraySessions];
	}
}

- (void)fetchFavoriteSessions:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	[self request:ticket didFailWithError:error];
	
	if ([_delegate respondsToSelector:@selector(fetchFavoriteSessionsDidFailWithError:)])
	{
		[_delegate fetchFavoriteSessionsDidFailWithError:error];
	}
}

- (void)fetchConferenceFavoriteSessionsByEventId:(NSString *)eventId
{
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
	
	[self cancelDataFetcherRequest];
	
	_dataFetcher = [[OAAsynchronousDataFetcher alloc] initWithRequest:request
															 delegate:self
													didFinishSelector:@selector(fetchConferenceFavoriteSessions:didFinishWithData:)
													  didFailSelector:@selector(fetchConferenceFavoriteSessions:didFailWithError:)];
	
	[_dataFetcher start];
	
	[request release];
}

- (void)fetchConferenceFavoriteSessions:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	[_dataFetcher release];
	_dataFetcher = nil;
	
	NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	DLog(@"%@", responseBody);
	
	NSMutableArray *arraySessions = [[[NSMutableArray alloc] init] autorelease];
	
	if (ticket.didSucceed)
	{	
		NSArray *array = [responseBody yajl_JSON];
		
		DLog(@"%@", array);
		
		for (NSDictionary *d in array) 
		{
			EventSession *session = [[EventSession alloc] initWithDictionary:d];
			[arraySessions addObject:session];			
			[session release];
		}
	}
	else 
	{
		[self request:ticket didNotSucceedWithDefaultMessage:@"A problem occurred while retrieving the session data."];
	}
	
	[responseBody release];
	
	if ([_delegate respondsToSelector:@selector(fetchConferenceFavoriteSessionsDidFinishWithResults:)])
	{
		[_delegate fetchConferenceFavoriteSessionsDidFinishWithResults:arraySessions];
	}
}

- (void)fetchConferenceFavoriteSessions:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	[self request:ticket didFailWithError:error];
	
	if ([_delegate respondsToSelector:@selector(fetchConferenceFavoriteSessionsDidFailWithError:)])
	{
		[_delegate fetchConferenceFavoriteSessionsDidFailWithError:error];
	}
}

- (void)updateFavoriteSession:(NSString *)sessionNumber withEventId:(NSString *)eventId;
{	
	sharedShouldRefreshFavorites = YES;
	
	NSString *urlString = [[NSString alloc] initWithFormat:EVENT_SESSIONS_FAVORITE_URL, eventId, sessionNumber];
	NSURL *url = [[NSURL alloc] initWithString:urlString];
	[urlString release];
	
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url 
																   consumer:[OAuthManager sharedInstance].consumer
																	  token:[OAuthManager sharedInstance].accessToken
																	  realm:OAUTH_REALM
														  signatureProvider:nil]; // use the default method, HMAC-SHA1
	
	[url release];
	
	[request setHTTPMethod:@"PUT"];
	
	DLog(@"%@", request);
	
	[self cancelDataFetcherRequest];
	
	_dataFetcher = [[OAAsynchronousDataFetcher alloc] initWithRequest:request
															 delegate:self
													didFinishSelector:@selector(updateFavoriteSession:didFinishWithData:)
													  didFailSelector:@selector(updateFavoriteSession:didFailWithError:)];
	
	[_dataFetcher start];
	
	[request release];
}

- (void)updateFavoriteSession:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	[_dataFetcher release];
	_dataFetcher = nil;
	
	NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

	DLog(@"%@", responseBody);
	
	BOOL isFavorite = NO;
	
	if (ticket.didSucceed)
	{
		isFavorite = [responseBody boolValue];
	}
	else 
	{
		[self request:ticket didNotSucceedWithDefaultMessage:@"A problem occurred while updating the favorite."];
	}
	
	[responseBody release];
	
	if ([_delegate respondsToSelector:@selector(updateFavoriteSessionDidFinishWithResults:)])
	{
		[_delegate updateFavoriteSessionDidFinishWithResults:isFavorite];
	}
}

- (void)updateFavoriteSession:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	[self request:ticket didFailWithError:error];
	
	if ([_delegate respondsToSelector:@selector(updateFavoriteSessionDidFailWithError:)])
	{
		[_delegate updateFavoriteSessionDidFailWithError:error];
	}
}

- (void)rateSession:(NSString *)sessionNumber withEventId:(NSString *)eventId rating:(NSInteger)rating comment:(NSString *)comment
{
	self.activityAlertiView = [[ActivityAlertView alloc] initWithActivityMessage:@"Submitting rating..."];
	[_activityAlertiView startAnimating];
	
	NSString *urlString = [[NSString alloc] initWithFormat:EVENT_SESSION_RATING_URL, eventId, sessionNumber];
	NSURL *url = [[NSURL alloc] initWithString:urlString];
	[urlString release];
	
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url 
																   consumer:[OAuthManager sharedInstance].consumer
																	  token:[OAuthManager sharedInstance].accessToken
																	  realm:OAUTH_REALM
														  signatureProvider:nil]; // use the default method, HMAC-SHA1
	
	[url release];
	
	NSString *s = [comment stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	
	s = [s URLEncodedString];
	
	NSString *postParams =[[NSString alloc] initWithFormat:@"value=%i&comment=%@", rating, s];
	DLog(@"%@", postParams);
		
	NSData *putData = [[postParams dataUsingEncoding:NSUTF8StringEncoding] retain];
	[postParams release];
	
	NSString *putLength = [NSString stringWithFormat:@"%d", [putData length]];
	
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setValue:putLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:putData];
	[putData release];
	
	DLog(@"%@", request);
	
	[self cancelDataFetcherRequest];
	
	_dataFetcher = [[OAAsynchronousDataFetcher alloc] initWithRequest:request
															 delegate:self
													didFinishSelector:@selector(rateSession:didFinishWithData:)
													  didFailSelector:@selector(rateSession:didFailWithError:)];
	
	[_dataFetcher start];
	
	[request release];
}

- (void)rateSession:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	[_dataFetcher release];
	_dataFetcher = nil;
	
	[_activityAlertiView stopAnimating];
	self.activityAlertiView = nil;
	
	NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

	DLog(@"%@", responseBody);
	
	if (!ticket.didSucceed)
	{
		[self request:ticket didNotSucceedWithDefaultMessage:@"A problem occurred while submitting the session rating."];
	}
	
	[responseBody release];
	
	if ([_delegate respondsToSelector:@selector(rateSessionDidFinish)])
	{
		[_delegate rateSessionDidFinish];
	}
}

- (void)rateSession:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	[_activityAlertiView stopAnimating];
	self.activityAlertiView = nil;

	[self request:ticket didFailWithError:error];
	
	if ([_delegate respondsToSelector:@selector(rateSessionDidFailWithError:)])
	{
		[_delegate rateSessionDidFailWithError:error];
	}
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc
{
	[super dealloc];
}

@end
