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
//  OAuthManager.h
//  Greenhouse
//
//  Created by Roy Clarkson on 6/7/10.
//

#import <Foundation/Foundation.h>
#import "ActivityAlertView.h"


@interface OAuthManager : NSObject 
{
	OAAsynchronousDataFetcher *_dataFetcher;
	ActivityAlertView *_activityAlertView;
	id delegate;
	SEL didFinishSelector;
	SEL didFailSelector;
}

@property (nonatomic, assign, readonly) BOOL authorized;
@property (nonatomic, assign, readonly) OAToken *accessToken;
@property (nonatomic, assign, readonly) OAConsumer *consumer;
@property (nonatomic, retain) ActivityAlertView *activityAlertView;

+ (OAuthManager *)sharedInstance;

- (BOOL)isAuthorized;
- (void)removeAccessToken;
- (void)cancelDataFetcherRequest;
- (void)fetchUnauthorizedRequestToken;
- (void)requestTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
- (void)requestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error;
- (void)authorizeRequestToken:(OAToken *)requestToken;
- (void)processOauthResponse:(NSURL *)url delegate:(id)aDelegate didFinishSelector:(SEL)finishSelector didFailSelector:(SEL)failSelector;
- (void)fetchAccessToken:(NSString *)oauthVerifier;
- (void)accessTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
- (void)accessTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error;

@end
