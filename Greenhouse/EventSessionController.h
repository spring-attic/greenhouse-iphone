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
//  EventSessionController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 9/7/10.
//

#import <Foundation/Foundation.h>
#import "OAuthController.h"
#import "EventSessionControllerDelegate.h"


@interface EventSessionController : OAuthController 
{ 
	id<EventSessionControllerDelegate> _delegate;
}

@property (nonatomic, assign) id<EventSessionControllerDelegate> delegate;

+ (BOOL)shouldRefreshFavorites;

- (void)fetchCurrentSessionsByEventId:(NSString *)eventId;
- (void)fetchCurrentSessions:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
- (void)fetchCurrentSessions:(OAServiceTicket *)ticket didFailWithError:(NSError *)error;
- (void)fetchSessionsByEventId:(NSString *)eventId withDate:(NSDate *)eventDate;
- (void)fetchSessions:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
- (void)fetchSessions:(OAServiceTicket *)ticket didFailWithError:(NSError *)error;
- (void)fetchFavoriteSessionsByEventId:(NSString *)eventId;
- (void)fetchFavoriteSessions:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
- (void)fetchFavoriteSessions:(OAServiceTicket *)ticket didFailWithError:(NSError *)error;
- (void)fetchConferenceFavoriteSessionsByEventId:(NSString *)eventId;
- (void)fetchConferenceFavoriteSessions:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
- (void)fetchConferenceFavoriteSessions:(OAServiceTicket *)ticket didFailWithError:(NSError *)error;
- (void)updateFavoriteSession:(NSString *)sessionNumber withEventId:(NSString *)eventId;
- (void)updateFavoriteSession:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
- (void)updateFavoriteSession:(OAServiceTicket *)ticket didFailWithError:(NSError *)error;
- (void)rateSession:(NSString *)sessionNumber withEventId:(NSString *)eventId rating:(NSInteger)rating comment:(NSString *)comment;
- (void)rateSession:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
- (void)rateSession:(OAServiceTicket *)ticket didFailWithError:(NSError *)error;

@end

