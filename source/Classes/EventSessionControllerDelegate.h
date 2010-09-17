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
- (void)fetchSessionsByDateDidFinishWithResults:(NSArray *)sessions andTimes:(NSArray *)times;
- (void)fetchFavoriteSessionsDidFinishWithResults:(NSArray *)sessions;
- (void)fetchConferenceFavoriteSessionsDidFinishWithResults:(NSArray *)sessions;
- (void)updateFavoriteSessionDidFinish;
- (void)rateSessionDidFinish;

@end

