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
//  GHEventSessionController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 9/7/10.
//

#import "GHBaseController.h"
#import "GHEventSessionControllerDelegate.h"


@interface GHEventSessionController : GHBaseController 

@property (nonatomic, unsafe_unretained) id<GHEventSessionControllerDelegate> delegate;

+ (BOOL)shouldRefreshFavorites;

- (void)fetchCurrentSessionsByEventId:(NSString *)eventId;
- (void)fetchCurrentSessionsDidFinishWithData:(NSData *)data;
- (void)fetchCurrentSessionsDidFailWithError:(NSError *)error;
- (void)fetchSessionsByEventId:(NSString *)eventId withDate:(NSDate *)eventDate;
- (void)fetchSessionsDidFinishWithData:(NSData *)data;
- (void)fetchSessionsDidFailWithError:(NSError *)error;
- (void)fetchFavoriteSessionsByEventId:(NSString *)eventId;
- (void)fetchFavoriteSessionsDidFinishWithData:(NSData *)data;
- (void)fetchFavoriteSessionsDidFailWithError:(NSError *)error;
- (void)fetchConferenceFavoriteSessionsByEventId:(NSString *)eventId;
- (void)fetchConferenceFavoriteSessionsDidFinishWithData:(NSData *)data;
- (void)fetchConferenceFavoriteSessionsDidFailWithError:(NSError *)error;
- (void)updateFavoriteSession:(NSString *)sessionNumber withEventId:(NSString *)eventId;
- (void)updateFavoriteSessionDidFinishWithData:(NSData *)data;
- (void)updateFavoriteSessionDidFailWithError:(NSError *)error;
- (void)rateSession:(NSString *)sessionNumber withEventId:(NSString *)eventId rating:(NSInteger)rating comment:(NSString *)comment;
- (void)rateSessionDidFinishWithData:(NSData *)data;
- (void)rateSessionDidFailWithError:(NSError *)error;

@end

