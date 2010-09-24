//
//  EventSessionControllerDelegate.h
//  Greenhouse
//
//  Created by Roy Clarkson on 9/16/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol EventSessionControllerDelegate

@optional

- (void)fetchCurrentSessionsDidFinishWithResults:(NSArray *)currentSessions upcomingSessions:(NSArray *)upcomingSessions;
- (void)fetchCurrentSessionsDidFailWithError:(NSError *)error;
- (void)fetchSessionsByDateDidFinishWithResults:(NSArray *)sessions andTimes:(NSArray *)times;
- (void)fetchSessionsByDateDidFailWithError:(NSError *)error;
- (void)fetchFavoriteSessionsDidFinishWithResults:(NSArray *)sessions;
- (void)fetchFavoriteSessionsDidFailWithError:(NSError *)error;
- (void)fetchConferenceFavoriteSessionsDidFinishWithResults:(NSArray *)sessions;
- (void)fetchConferenceFavoriteSessionsDidFailWithError:(NSError *)error;
- (void)updateFavoriteSessionDidFinishWithResults:(BOOL)isFavorite;
- (void)updateFavoriteSessionDidFailWithError:(NSError *)error;
- (void)rateSessionDidFinish;
- (void)rateSessionDidFailWithError:(NSError *)error;

@end

