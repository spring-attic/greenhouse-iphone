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
//  GHTwitterController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 8/27/10.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "GHOAuthController.h"
#import "GHTwitterControllerDelegate.h"


@interface GHTwitterController : GHOAuthController

@property (nonatomic, unsafe_unretained) id<GHTwitterControllerDelegate> delegate;

- (void)fetchTweetsWithURL:(NSURL *)url page:(NSUInteger)page;
- (void)fetchTweets:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
- (void)fetchTweets:(OAServiceTicket *)ticket didFailWithError:(NSError *)error;
- (void)postUpdate:(NSString *)update withURL:(NSURL *)url;
- (void)postUpdate:(NSString *)update withURL:(NSURL *)url location:(CLLocation *)location;
- (void)postUpdate:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
- (void)postUpdate:(OAServiceTicket *)ticket didFailWithError:(NSError *)error;
- (void)postRetweet:(NSString *)tweetId withURL:(NSURL *)url;
- (void)postRetweet:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
- (void)postRetweet:(OAServiceTicket *)ticket didFailWithError:(NSError *)error;

@end
