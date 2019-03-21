//
//  Copyright 2012 the original author or authors.
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
//  OA2AccessGrantTests.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/17/12.
//

#import "OA2AccessGrantTests.h"

#define VALUE_ACCESS_TOKEN      @"057b391a-c2d5-4844-b527-eee32bed3aa5"
#define VALUE_SCOPE             @"read write"
#define VALUE_REFRESH_TOKEN     @"89d264f4-2481-4d9b-a81f-128e964d9cd8"
#define VALUE_EXPIRES_IN        43199
#define VALUE_EXPIRE_TIME       1777785364.514293

@interface OA2AccessGrantTests ()

@property (nonatomic, strong) NSString *jsonString;

- (void)validateAccessGrant:(OA2AccessGrant *)accessGrant;
- (void)validateAccessGrant:(OA2AccessGrant *)accessGrant currentTimeMilliseconds:(NSNumber *)currentTimeMillis;
- (void)compareAccessGrant:(OA2AccessGrant *)accessGrant withAccessGrant:(OA2AccessGrant *)accessGrant2;

@end

@implementation OA2AccessGrantTests

@synthesize jsonString;


#pragma mark -
#pragma mark SenTestCase methods

- (void)setUp
{
    [super setUp];
    
    self.jsonString = @"{\"access_token\":\"057b391a-c2d5-4844-b527-eee32bed3aa5\",\"token_type\":\"bearer\",\"refresh_token\":\"89d264f4-2481-4d9b-a81f-128e964d9cd8\",\"expires_in\":43199,\"scope\":\"read write\"}";
}

- (void)tearDown
{
    [super tearDown];
}


#pragma mark -
#pragma mark Test methods

- (void)testInit
{
    OA2AccessGrant *accessGrant = [[OA2AccessGrant alloc] init];
    STAssertNil(accessGrant.accessToken, @"access token should be nil");
    STAssertNil(accessGrant.scope, @"scope should be nil");
    STAssertNil(accessGrant.refreshToken, @"refresh token should be nil");
    STAssertEquals(0.0, accessGrant.expireTime, @"expire time should be 0");
}

- (void)testInitWithData
{
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    OA2AccessGrant *accessGrant = [[OA2AccessGrant alloc] initWithData:data error:&error];
    STAssertNil(error, @"should not have an error");
    [self validateAccessGrant:accessGrant];
}

- (void)testInitWithDataNil
{
    NSData *data = nil;
    NSError *error;
    OA2AccessGrant *accessGrant = [[OA2AccessGrant alloc] initWithData:data error:&error];
    STAssertNotNil(error, @"should have an error");
    STAssertTrue([[error localizedDescription] isEqualToString:@"data parameter is nil"],
                 [NSString stringWithFormat:@"should be data parameter is nil, but was %@", [error localizedDescription]]);
    STAssertNotNil(accessGrant, @"access grant should be nil");
}

- (void)testInitWithDictionary
{
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                VALUE_ACCESS_TOKEN, @"access_token",
                                VALUE_REFRESH_TOKEN, @"refresh_token",
                                VALUE_SCOPE, @"scope",
                                [NSNumber numberWithInteger:VALUE_EXPIRES_IN], @"expires_in",
                                nil];
    NSError *error;
    OA2AccessGrant *accessGrant = [[OA2AccessGrant alloc] initWithDictionary:dictionary error:&error];
    STAssertNil(error, @"should not have an error");
    [self validateAccessGrant:accessGrant];
}

- (void)testInitWithDictionaryNil
{
    NSDictionary *dictionary = nil;
    NSError *error;
    OA2AccessGrant *accessGrant = [[OA2AccessGrant alloc] initWithDictionary:dictionary error:&error];
    STAssertNotNil(error, @"should have an error");
    STAssertTrue([[error localizedDescription] isEqualToString:@"dictionary parameter is nil"],
                 [NSString stringWithFormat:@"should be dictionary parameter is nil, but was %@", [error localizedDescription]]);
    STAssertNotNil(accessGrant, @"access grant should be nil");
}


- (void)testInitWithAccessTokenScopeRefreshTokenExpiresIn
{
    NSNumber *currentTimeMillis;
    OA2AccessGrant *accessGrant = [[OA2AccessGrant alloc] initWithAccessToken:VALUE_ACCESS_TOKEN
                                                                        scope:VALUE_SCOPE
                                                                 refreshToken:VALUE_REFRESH_TOKEN
                                                                    expiresIn:[NSNumber numberWithInteger:VALUE_EXPIRES_IN]
                                                      currentTimeMilliseconds:&currentTimeMillis];
    [self validateAccessGrant:accessGrant currentTimeMilliseconds:currentTimeMillis];
}

- (void)testInitWithAccessTokenScopeRefreshTokenExpireTime
{
    NSNumber *currentTimeMillis;
    NSTimeInterval expireTime = [OA2AccessGrant expireTimeWithExpiresIn:[NSNumber numberWithInteger:VALUE_EXPIRES_IN]
                                                currentTimeMilliseconds:&currentTimeMillis];
    OA2AccessGrant *accessGrant = [[OA2AccessGrant alloc] initWithAccessToken:VALUE_ACCESS_TOKEN
                                                                        scope:VALUE_SCOPE
                                                                 refreshToken:VALUE_REFRESH_TOKEN
                                                                    expireTime:expireTime];
    [self validateAccessGrant:accessGrant currentTimeMilliseconds:currentTimeMillis];
}

- (void)testDictionaryValue
{
    OA2AccessGrant *accessGrant = [[OA2AccessGrant alloc] initWithAccessToken:VALUE_ACCESS_TOKEN
                                                                        scope:VALUE_SCOPE
                                                                 refreshToken:VALUE_REFRESH_TOKEN
                                                                   expireTime:VALUE_EXPIRE_TIME];
    NSDictionary *dictionary = [accessGrant dictionaryValue];
    STAssertNotNil(dictionary, @"dictionary is nil");

    NSError *error;
    OA2AccessGrant *accessGrant2 = [[OA2AccessGrant alloc] initWithDictionary:dictionary error:&error];
    [self compareAccessGrant:accessGrant withAccessGrant:accessGrant2];
}

- (void)testDictionaryValueWithExpiresIn
{
    OA2AccessGrant *accessGrant = [[OA2AccessGrant alloc] initWithAccessToken:VALUE_ACCESS_TOKEN
                                                                        scope:VALUE_SCOPE
                                                                 refreshToken:VALUE_REFRESH_TOKEN
                                                                   expiresIn:[NSNumber numberWithDouble:VALUE_EXPIRES_IN]];
    NSDictionary *dictionary = [accessGrant dictionaryValue];
    STAssertNotNil(dictionary, @"dictionary is nil");
    
    NSError *error;
    OA2AccessGrant *accessGrant2 = [[OA2AccessGrant alloc] initWithDictionary:dictionary error:&error];
    [self compareAccessGrant:accessGrant withAccessGrant:accessGrant2];
}

- (void)testDictionaryValueNil
{
    OA2AccessGrant *accessGrant = [[OA2AccessGrant alloc] init];
    NSDictionary *dictionary = [accessGrant dictionaryValue];
    STAssertNotNil(dictionary, @"data is nil");
    STAssertNil(accessGrant.accessToken, @"access token should be nil");
    STAssertNil(accessGrant.scope, @"scope should be nil");
    STAssertNil(accessGrant.refreshToken, @"refresh token should be nil");
    STAssertEquals(0.0, accessGrant.expireTime, @"expire time should be 0");
    
    NSError *error;
    OA2AccessGrant *accessGrant2 = [[OA2AccessGrant alloc] initWithDictionary:dictionary error:&error];
    STAssertNil(accessGrant2.accessToken, @"access token should be nil");
    STAssertNil(accessGrant2.scope, @"scope should be nil");
    STAssertNil(accessGrant2.refreshToken, @"refresh token should be nil");
    STAssertEquals(0.0, accessGrant2.expireTime, @"expire time should be 0");
}

- (void)testDataValue
{
    OA2AccessGrant *accessGrant = [[OA2AccessGrant alloc] initWithAccessToken:VALUE_ACCESS_TOKEN
                                                                        scope:VALUE_SCOPE
                                                                 refreshToken:VALUE_REFRESH_TOKEN
                                                                   expireTime:VALUE_EXPIRE_TIME];
    NSData *data = [accessGrant dataValue];
    STAssertNotNil(data, @"data is nil");

    NSError *error;
    OA2AccessGrant *accessGrant2 = [[OA2AccessGrant alloc] initWithData:data error:&error];
    [self compareAccessGrant:accessGrant withAccessGrant:accessGrant2];
}

- (void)testDataValueWithExpiresIn
{
    OA2AccessGrant *accessGrant = [[OA2AccessGrant alloc] initWithAccessToken:VALUE_ACCESS_TOKEN
                                                                        scope:VALUE_SCOPE
                                                                 refreshToken:VALUE_REFRESH_TOKEN
                                                                    expiresIn:[NSNumber numberWithDouble:VALUE_EXPIRES_IN]];
    NSData *data = [accessGrant dataValue];
    STAssertNotNil(data, @"data is nil");
    
    NSError *error;
    OA2AccessGrant *accessGrant2 = [[OA2AccessGrant alloc] initWithData:data error:&error];
    [self compareAccessGrant:accessGrant withAccessGrant:accessGrant2];
}

- (void)testDataValueNil
{
    OA2AccessGrant *accessGrant = [[OA2AccessGrant alloc] init];
    NSData *data = [accessGrant dataValue];
    STAssertNotNil(data, @"data is nil");
    STAssertNil(accessGrant.accessToken, @"access token should be nil");
    STAssertNil(accessGrant.scope, @"scope should be nil");
    STAssertNil(accessGrant.refreshToken, @"refresh token should be nil");
    STAssertEquals(0.0, accessGrant.expireTime, @"expire time should be 0");
    
    NSError *error;
    OA2AccessGrant *accessGrant2 = [[OA2AccessGrant alloc] initWithData:data error:&error];
    STAssertNil(accessGrant2.accessToken, @"access token should be nil");
    STAssertNil(accessGrant2.scope, @"scope should be nil");
    STAssertNil(accessGrant2.refreshToken, @"refresh token should be nil");
    STAssertEquals(0.0, accessGrant2.expireTime, @"expire time should be 0");
}


#pragma mark -
#pragma mark Helper methods

- (void)validateAccessGrant:(OA2AccessGrant *)accessGrant
{
    [self validateAccessGrant:accessGrant currentTimeMilliseconds:nil];
}

- (void)validateAccessGrant:(OA2AccessGrant *)accessGrant currentTimeMilliseconds:(NSNumber *)currentTimeMillis
{
    STAssertTrue([accessGrant.accessToken isEqualToString:VALUE_ACCESS_TOKEN], @"access tokens are not equal");
    STAssertTrue([accessGrant.scope isEqualToString:VALUE_SCOPE], @"scopes are not equal");
    STAssertTrue([accessGrant.refreshToken isEqualToString:VALUE_REFRESH_TOKEN], @"refresh tokens are not equal");
    if (currentTimeMillis)
    {
        NSInteger expiresIn = (accessGrant.expireTime - [currentTimeMillis doubleValue]) / 10001;
        STAssertEquals(expiresIn, VALUE_EXPIRES_IN, @"expire times are not equal");
    }
}

- (void)compareAccessGrant:(OA2AccessGrant *)accessGrant withAccessGrant:(OA2AccessGrant *)accessGrant2
{
    STAssertTrue([accessGrant.accessToken isEqualToString:accessGrant2.accessToken], @"access tokens do not match");
    STAssertTrue([accessGrant.scope isEqualToString:accessGrant2.scope], @"access tokens do not match");
    STAssertTrue([accessGrant.refreshToken isEqualToString:accessGrant2.refreshToken], @"access tokens do not match");
    STAssertEqualsWithAccuracy(accessGrant.expireTime, accessGrant2.expireTime, 0.000001, @"expire times are not equal");
}

@end
