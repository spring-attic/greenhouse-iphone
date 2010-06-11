//
//  OAuthManager.h
//  Greenhouse
//
//  Created by Roy Clarkson on 6/7/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OauthConsumer.h"


@interface OAuthManager : NSObject { }

@property (nonatomic, assign, getter=isAuthorized) BOOL authorized;

+ (OAuthManager *)sharedInstance;

- (BOOL)isAuthorized;
- (void)fetchUnauthorizedRequestToken;
- (void)requestTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
- (void)requestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error;
- (void)authorizeRequestToken:(OAToken *)requestToken;
- (void)processOauthResponse:(NSURL *)url;
- (void)fetchAccessToken:(NSString *)oauthVerifier;
- (void)accessTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
- (void)accessTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error;
//- (void)updateStatus:(NSString *)status;
//- (void)updateStatusTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
//- (void)updateStatusTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error;
@end
