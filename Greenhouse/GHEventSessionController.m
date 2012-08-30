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
//  GHEventSessionController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 9/7/10.
//

#import "GHEventSessionController.h"
#import "GHEventSession.h"

static BOOL sharedShouldRefreshFavorites;

@implementation GHEventSessionController

@synthesize delegate;

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
	// request the sessions for the current day
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"YYYY-MM-d"];
	NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
	NSString *urlString = [[NSString alloc] initWithFormat:EVENT_SESSIONS_BY_DAY_URL, eventId, dateString];
	NSURL *url = [[NSURL alloc] initWithString:urlString];
	
    NSMutableURLRequest *request = [[GHAuthorizedRequest alloc] initWithURL:url];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	
	DLog(@"%@", request);
	
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
         if (statusCode == 200 && data.length > 0 && error == nil)
         {
             [self fetchCurrentSessionsDidFinishWithData:data];
         }
         else if (error)
         {
             [self fetchCurrentSessionsDidFailWithError:error];
         }
         else if (statusCode != 200)
         {
             [self requestDidNotSucceedWithDefaultMessage:@"A problem occurred while retrieving the session data." response:response];
         }
     }];
}

- (void)fetchCurrentSessionsDidFinishWithData:(NSData *)data
{
	DLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
	
	NSMutableArray *arrayCurrentSessions = [[NSMutableArray alloc] init];
	NSMutableArray *arrayUpcomingSessions = [[NSMutableArray alloc] init];
    
    NSError *error;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if (!error)
    {
        DLog(@"%@", jsonArray);
        
        NSDate *nextStartTime = nil;
        NSDate *now = [NSDate date];
        DLog(@"%@", now.description);
        
        for (NSDictionary *d in jsonArray)
        {
            GHEventSession *session = [[GHEventSession alloc] initWithDictionary:d];
            DLog(@"%@ - %@", [session.startTime description], [session.endTime description]);
            
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
        }
    }

	if ([delegate respondsToSelector:@selector(fetchCurrentSessionsDidFinishWithResults:upcomingSessions:)])
	{
		DLog(@"arrayCurrentSessions: %@", arrayCurrentSessions);
		DLog(@"arrayUpcomingSessions: %@", arrayUpcomingSessions);

		[delegate fetchCurrentSessionsDidFinishWithResults:arrayCurrentSessions upcomingSessions:arrayUpcomingSessions];
	}
}

- (void)fetchCurrentSessionsDidFailWithError:(NSError *)error
{
	[self requestDidFailWithError:error];
	
	if ([delegate respondsToSelector:@selector(fetchCurrentSessionsDidFailWithError:)])
	{
		[delegate fetchCurrentSessionsDidFailWithError:error];
	}	
}

- (void)fetchSessionsByEventId:(NSString *)eventId withDate:(NSDate *)eventDate;
{
	// request the sessions for the selected day
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"YYYY-MM-d"];
	NSString *dateString = [dateFormatter stringFromDate:eventDate];
	NSString *urlString = [[NSString alloc] initWithFormat:EVENT_SESSIONS_BY_DAY_URL, eventId, dateString];
	NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *request = [[GHAuthorizedRequest alloc] initWithURL:url];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	DLog(@"%@", request);
	
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
         if (statusCode == 200 && data.length > 0 && error == nil)
         {
             [self fetchSessionsDidFinishWithData:data];
         }
         else if (error)
         {
             [self fetchSessionsDidFailWithError:error];
         }
         else if (statusCode != 200)
         {
             [self requestDidNotSucceedWithDefaultMessage:@"A problem occurred while retrieving the session data." response:response];
         }
     }];
}

- (void)fetchSessionsDidFinishWithData:(NSData *)data
{
	NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	DLog(@"%@", responseBody);

	NSMutableArray *arraySessions = [[NSMutableArray alloc] init];
	NSMutableArray *arrayTimes = [[NSMutableArray alloc] init];
    
    NSError *error;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if (!error)
    {
        DLog(@"%@", array);
        
        NSMutableArray *arrayBlock = nil;
        NSDate *sessionTime = [NSDate distantPast];
        
        for (NSDictionary *d in array)
        {
            GHEventSession *session = [[GHEventSession alloc] initWithDictionary:d];
            
            // for each time block create an array to hold the sessions for that block
            if ([sessionTime compare:session.startTime] == NSOrderedAscending)
            {
                arrayBlock = [[NSMutableArray alloc] init];
                [arraySessions addObject:arrayBlock];
                [arrayBlock addObject:session];
                
                NSDate *date = [session.startTime copyWithZone:NULL];
                [arrayTimes addObject:date];
            }
            else if ([sessionTime compare:session.startTime] == NSOrderedSame)
            {
                [arrayBlock addObject:session];
            }
            
            sessionTime = session.startTime;
        }
    }
	
	if ([delegate respondsToSelector:@selector(fetchSessionsByDateDidFinishWithResults:andTimes:)])
	{
		DLog(@"arraySessions: %@", arraySessions);
		DLog(@"arrayTimes: %@", arrayTimes);
		
		[delegate fetchSessionsByDateDidFinishWithResults:arraySessions andTimes:arrayTimes];
	}
}

- (void)fetchSessionsDidFailWithError:(NSError *)error
{
	[self requestDidFailWithError:error];
	
	if ([delegate respondsToSelector:@selector(fetchSessionsByDateDidFailWithError:)])
	{
		[delegate fetchSessionsByDateDidFailWithError:error];
	}
}

- (void)fetchFavoriteSessionsByEventId:(NSString *)eventId
{
	sharedShouldRefreshFavorites = NO;
	
	NSString *urlString = [[NSString alloc] initWithFormat:EVENT_SESSIONS_FAVORITES_URL, eventId];
	NSURL *url = [[NSURL alloc] initWithString:urlString];
	
    NSMutableURLRequest *request = [[GHAuthorizedRequest alloc] initWithURL:url];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	DLog(@"%@", request);
	
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
         if (statusCode == 200 && data.length > 0 && error == nil)
         {
             [self fetchFavoriteSessionsDidFinishWithData:data];
         }
         else if (error)
         {
             [self fetchFavoriteSessionsDidFailWithError:error];
         }
         else if (statusCode != 200)
         {
             [self requestDidNotSucceedWithDefaultMessage:@"A problem occurred while retrieving the session data." response:response];
         }
     }];
}

- (void)fetchFavoriteSessionsDidFinishWithData:(NSData *)data
{
	DLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
	
    NSError *error;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    NSMutableArray *arraySessions = [[NSMutableArray alloc] init];
    if (!error)
    {
        DLog(@"%@", array);
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [arraySessions addObject:[[GHEventSession alloc] initWithDictionary:obj]];
        }];
    }
    
	if ([delegate respondsToSelector:@selector(fetchFavoriteSessionsDidFinishWithResults:)])
	{
		[delegate fetchFavoriteSessionsDidFinishWithResults:arraySessions];
	}
}

- (void)fetchFavoriteSessionsDidFailWithError:(NSError *)error
{
	[self requestDidFailWithError:error];
	
	if ([delegate respondsToSelector:@selector(fetchFavoriteSessionsDidFailWithError:)])
	{
		[delegate fetchFavoriteSessionsDidFailWithError:error];
	}
}

- (void)fetchConferenceFavoriteSessionsByEventId:(NSString *)eventId
{
	NSString *urlString = [[NSString alloc] initWithFormat:EVENT_SESSIONS_CONFERENCE_FAVORITES_URL, eventId];
	NSURL *url = [[NSURL alloc] initWithString:urlString];
	
    NSMutableURLRequest *request = [[GHAuthorizedRequest alloc] initWithURL:url];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	DLog(@"%@", request);
	
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
         if (statusCode == 200 && data.length > 0 && error == nil)
         {
             [self fetchConferenceFavoriteSessionsDidFinishWithData:data];
         }
         else if (error)
         {
             [self fetchConferenceFavoriteSessionsDidFailWithError:error];
         }
         else if (statusCode != 200)
         {
             [self requestDidNotSucceedWithDefaultMessage:@"A problem occurred while retrieving the session data." response:response];
         }
     }];
}

- (void)fetchConferenceFavoriteSessionsDidFinishWithData:(NSData *)data
{
	DLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);

    NSError *error;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    NSMutableArray *arraySessions = [[NSMutableArray alloc] init];
    if (!error)
    {
        DLog(@"%@", array);
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [arraySessions addObject:[[GHEventSession alloc] initWithDictionary:obj]];
        }];
    }
    	
	if ([delegate respondsToSelector:@selector(fetchConferenceFavoriteSessionsDidFinishWithResults:)])
	{
		[delegate fetchConferenceFavoriteSessionsDidFinishWithResults:arraySessions];
	}
}

- (void)fetchConferenceFavoriteSessionsDidFailWithError:(NSError *)error
{
	[self requestDidFailWithError:error];
	
	if ([delegate respondsToSelector:@selector(fetchConferenceFavoriteSessionsDidFailWithError:)])
	{
		[delegate fetchConferenceFavoriteSessionsDidFailWithError:error];
	}
}

- (void)updateFavoriteSession:(NSString *)sessionNumber withEventId:(NSString *)eventId;
{	
	sharedShouldRefreshFavorites = YES;
	
	NSString *urlString = [[NSString alloc] initWithFormat:EVENT_SESSIONS_FAVORITE_URL, eventId, sessionNumber];
	NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *request = [[GHAuthorizedRequest alloc] initWithURL:url];
	[request setHTTPMethod:@"PUT"];	
	DLog(@"%@", request);

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
         if (statusCode == 200 && data.length > 0 && error == nil)
         {
             [self updateFavoriteSessionDidFinishWithData:data];
         }
         else if (error)
         {
             [self updateFavoriteSessionDidFailWithError:error];
         }
         else if (statusCode != 200)
         {
             [self requestDidNotSucceedWithDefaultMessage:@"A problem occurred while updating the favorite." response:response];
         }
     }];
}

- (void)updateFavoriteSessionDidFinishWithData:(NSData *)data
{
	NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	DLog(@"%@", responseBody);
	
	BOOL isFavorite = [responseBody boolValue];
	
	if ([delegate respondsToSelector:@selector(updateFavoriteSessionDidFinishWithResults:)])
	{
		[delegate updateFavoriteSessionDidFinishWithResults:isFavorite];
	}
}

- (void)updateFavoriteSessionDidFailWithError:(NSError *)error
{
	[self requestDidFailWithError:error];
	
	if ([delegate respondsToSelector:@selector(updateFavoriteSessionDidFailWithError:)])
	{
		[delegate updateFavoriteSessionDidFailWithError:error];
	}
}

- (void)rateSession:(NSString *)sessionNumber withEventId:(NSString *)eventId rating:(NSInteger)rating comment:(NSString *)comment
{
	self.activityAlertView = [[GHActivityAlertView alloc] initWithActivityMessage:@"Submitting rating..."];
	[_activityAlertView startAnimating];
	
	NSString *urlString = [[NSString alloc] initWithFormat:EVENT_SESSION_RATING_URL, eventId, sessionNumber];
	NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *request = [[GHAuthorizedRequest alloc] initWithURL:url];
	
	NSString *trimmedComment = [comment stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	NSString *postParams =[[NSString alloc] initWithFormat:@"value=%i&comment=%@", rating, [trimmedComment stringByURLEncoding]];
	DLog(@"%@", postParams);
	NSData *putData = [postParams dataUsingEncoding:NSUTF8StringEncoding];
	NSString *putLength = [NSString stringWithFormat:@"%d", [putData length]];
	
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setValue:putLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:putData];
	
	DLog(@"%@", request);
	
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         [_activityAlertView stopAnimating];
         self.activityAlertView = nil;
         
         NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
         if (statusCode == 200 && data.length > 0 && error == nil)
         {
             [self rateSessionDidFinishWithData:data];
         }
         else if (error)
         {
             [self rateSessionDidFailWithError:error];
         }
         else if (statusCode != 200)
         {
             if (statusCode == 412)
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                     message:@"This session has not yet finished. Please wait until the session has completed before submitting your rating."
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
                 [alertView show];
             }
             else 
             {
                 [self requestDidNotSucceedWithDefaultMessage:@"A problem occurred while submitting the session rating." response:response];
             }
         }
     }];
}

- (void)rateSessionDidFinishWithData:(NSData *)data
{
	NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	DLog(@"%@", responseBody);
    
    double rating = [responseBody doubleValue];
    
    if ([delegate respondsToSelector:@selector(rateSessionDidFinishWithResults:)])
    {
        [delegate rateSessionDidFinishWithResults:rating];
    }
}

- (void)rateSessionDidFailWithError:(NSError *)error
{
	[self requestDidFailWithError:error];
	
	if ([delegate respondsToSelector:@selector(rateSessionDidFailWithError:)])
	{
		[delegate rateSessionDidFailWithError:error];
	}
}

@end
