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
//  GHTwitterController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 8/27/10.
//

#import "GHBaseController.h"
#import "GHTwitterControllerDelegate.h"

@class Tweet;

@interface GHTwitterController : GHBaseController

+ (id)sharedInstance;
+ (NSInteger)pageSize;

- (Tweet *)fetchTweetWithId:(NSString *)tweetId;
- (NSArray *)fetchTweetsWithEventId:(NSNumber *)eventId;
- (NSArray *)fetchTweetsWithEventId:(NSNumber *)eventId sessionNumber:(NSNumber *)sessionNumber;
- (Tweet *)fetchSelectedTweet;
- (void)setSelectedTweet:(Tweet *)tweet;

- (void)sendRequestForTweetsWithEventId:(NSNumber *)eventId page:(NSUInteger)page delegate:(id<GHTwitterControllerDelegate>)delegate;
- (void)sendRequestForTweetsWithEventId:(NSNumber *)eventId sessionNumber:(NSNumber *)sessionNumber page:(NSUInteger)page delegate:(id<GHTwitterControllerDelegate>)delegate;

- (void)postUpdate:(NSString *)update eventId:(NSNumber *)eventId delegate:(id<GHTwitterControllerDelegate>)delegate;
- (void)postUpdate:(NSString *)update eventId:(NSNumber *)eventId sessionNumber:(NSNumber *)sessionNumber delegate:(id<GHTwitterControllerDelegate>)delegate;

- (void)postRetweetWithTweetId:(NSString *)tweetId eventId:(NSNumber *)eventId delegate:(id<GHTwitterControllerDelegate>)delegate;
- (void)postRetweetWithTweetId:(NSString *)tweetId eventId:(NSNumber *)eventId sessionNumber:(NSNumber *)sessionNumber delegate:(id<GHTwitterControllerDelegate>)delegate;;


@end
