//
//  EventSessionController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 9/7/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthController.h"
#import "EventSessionControllerDelegate.h"


@interface EventSessionController : OAuthController 
{ 
	id<EventSessionControllerDelegate> _delegate;
}

@property (nonatomic, assign) id<EventSessionControllerDelegate> delegate;

+ (EventSessionController *)eventSessionController;
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

