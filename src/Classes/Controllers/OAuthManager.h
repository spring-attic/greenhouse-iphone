//
//  OAuthManager.h
//  Greenhouse
//
//  Created by Roy Clarkson on 6/7/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
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
