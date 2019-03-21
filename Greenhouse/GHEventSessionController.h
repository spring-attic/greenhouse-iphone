//
//  Copyright 2010-2012 the original author or authors.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//
//  GHEventSessionController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 9/7/10.
//

#import "GHBaseController.h"
#import "GHEventSessionsByDateDelegate.h"
#import "GHEventSessionsCurrentDelegate.h"
#import "GHEventSessionUpdateFavoriteDelegate.h"
#import "GHEventSessionRateDelegate.h"
#import "GHEventSessionsFavoritesDelegate.h"
#import "GHEventSessionsConferenceFavoritesDelegate.h"

@class EventSession;

@interface GHEventSessionController : GHBaseController

+ (id)sharedInstance;

- (EventSession *)fetchSessionWithNumber:(NSNumber *)number;
- (NSArray *)fetchSessionsWithEventId:(NSNumber *)eventId;
- (NSArray *)fetchSessionsWithEventId:(NSNumber *)eventId date:(NSDate *)eventDate;
- (EventSession *)fetchSelectedSession;
- (void)setSelectedSession:(EventSession *)session;
- (NSDate *)fetchSelectedScheduleDate;
- (void)setSelectedScheduleDate:(NSDate *)date;

- (void)sendRequestForSessionsWithEventId:(NSNumber *)eventId date:(NSDate *)eventDate delegate:(id<GHEventSessionsByDateDelegate>)delegate;
- (void)storeSessionsWithEventId:(NSNumber *)eventId json:(NSArray *)array;
- (EventSession *)createSessionWithEventId:(NSNumber *)eventId json:(NSDictionary *)dictionary;
- (void)deleteSessionsWithEventId:(NSNumber *)eventId date:(NSDate *)date;

- (NSArray *)fetchFavoriteSessionsWithEventId:(NSNumber *)eventId;
- (void)sendRequestForFavoriteSessionsByEventId:(NSNumber *)eventId delegate:(id<GHEventSessionsFavoritesDelegate>)delegate;

- (void)updateFavoriteSessionWithEventId:(NSNumber *)eventId sessionNumber:(NSNumber *)sessionNumber delegate:(id<GHEventSessionUpdateFavoriteDelegate>)delegate;
- (void)sendRequestToUpdateFavoriteSessionWithEventId:(NSNumber *)eventId sessionNumber:(NSNumber *)sessionNumber delegate:(id<GHEventSessionUpdateFavoriteDelegate>)delegate;

- (void)rateSession:(NSNumber *)sessionNumber withEventId:(NSNumber *)eventId rating:(NSInteger)rating comment:(NSString *)comment delegate:(id<GHEventSessionRateDelegate>)delegate;


- (void)fetchCurrentSessionsWithEventId:(NSNumber *)eventId delegate:(id<GHEventSessionsCurrentDelegate>)delegate;
- (void)sendRequestForCurrentSessionsWithEventId:(NSNumber *)eventId delegate:(id<GHEventSessionsCurrentDelegate>)delegate;
- (void)fetchConferenceFavoriteSessionsByEventId:(NSNumber *)eventId delegate:(id<GHEventSessionsConferenceFavoritesDelegate>)delegate;

@end

