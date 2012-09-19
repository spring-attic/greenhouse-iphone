//
//  Copyright 2012 the original author or authors.
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
//  GHOAuth2Controller.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/14/12.
//

#define KEYCHAIN_SERVICE_NAME    @"Greenhouse"
#define KEYCHAIN_ACCOUNT_NAME    @"OAuth2"

#import "GHOAuth2Controller.h"
#import "OA2SignInRequestParameters.h"
#import "GHURLPostRequest.h"
#import "GHKeychainManager.h"
#import "GHConnectionSettings.h"

@implementation GHOAuth2Controller


#pragma mark -
#pragma mark Static methods

// Use this class method to obtain the shared instance of the class.
+ (GHOAuth2Controller *)sharedInstance
{
    static GHOAuth2Controller *_sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _sharedInstance = [[GHOAuth2Controller alloc] init];
    });
    return _sharedInstance;
}


#pragma mark -
#pragma mark Instance methods

+ (BOOL)isAuthorized
{
    OA2AccessGrant *accessGrant = [self fetchAccessGrant];
    return (accessGrant != nil);
}

- (NSURLRequest *)signInRequestWithUsername:(NSString *)username password:(NSString *)password
{
    OA2SignInRequestParameters *parameters = [[OA2SignInRequestParameters alloc] initWithUsername:username password:password];
    NSURL *url = [GHConnectionSettings urlWithFormat:@"/oauth/token"];
    return [[GHURLPostRequest alloc] initWithURL:url parameters:parameters];
}

+ (BOOL)storeAccessGrant:(OA2AccessGrant *)accessGrant
{
	OSStatus status = [[GHKeychainManager sharedInstance] storePassword:[accessGrant dataValue] service:KEYCHAIN_SERVICE_NAME account:KEYCHAIN_ACCOUNT_NAME];
	return (status == errSecSuccess);
}

+ (OA2AccessGrant *)fetchAccessGrant
{
    NSData *passwordData;
    OSStatus status = [[GHKeychainManager sharedInstance] fetchPassword:&passwordData service:KEYCHAIN_SERVICE_NAME account:KEYCHAIN_ACCOUNT_NAME];
    if (status == errSecSuccess && passwordData)
    {
        NSError *error;
        OA2AccessGrant *accessGrant = [[OA2AccessGrant alloc] initWithData:passwordData error:&error];
        return accessGrant;
    }
    return nil;
}

+ (BOOL)deleteAccessGrant
{
	OSStatus status = [[GHKeychainManager sharedInstance] deletePasswordWithService:KEYCHAIN_SERVICE_NAME account:KEYCHAIN_ACCOUNT_NAME];
	return (status == errSecSuccess);
}

@end
