//
//  OAuthManager.h
//  OAuthSample
//
//  Created by Roy Clarkson on 6/3/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthConsumer.h"


@interface OAuthManager : NSObject 
{

}

+ (OAuthManager *)sharedInstance;

- (void)fetchUnauthorizedRequestToken;
- (void)requestTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
- (void)requestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error;
- (void)authorizeRequestToken:(OAToken *)requestToken;
- (void)processOauthResponse:(NSURL *)url;
- (void)fetchAccessToken:(NSString *)oauthVerifier;
- (void)accessTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
- (void)accessTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error;
- (void)updateStatus:(NSString *)status;
- (void)updateStatusTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
- (void)updateStatusTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error;


@end
