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
//  GHAuthControllerTests.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/21/12.
//

#import "GHAuthControllerTests.h"
#import "GHAuthController.h"
#import "OA2AccessGrant.h"

@implementation GHAuthControllerTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}


#pragma mark -
#pragma mark Test methods

- (void)testAccessGrantStorage
{
    OA2AccessGrant *accessGrant = [[OA2AccessGrant alloc] initWithAccessToken:@"057b391a-c2d5-4844-b527-eee32bed3aa5"
                                                                        scope:@"read write"
                                                                 refreshToken:@"89d264f4-2481-4d9b-a81f-128e964d9cd8"
                                                                    expireTime:1777785364.514293];
    
    BOOL result = [GHAuthController storeAccessGrant:accessGrant];
    STAssertTrue(result, @"failed to store access grant in keychain");
    
    OA2AccessGrant *accessGrant2 = [GHAuthController fetchAccessGrant];
    STAssertNotNil(accessGrant2.accessToken, @"token is nil");
    STAssertTrue([accessGrant.accessToken isEqualToString:accessGrant2.accessToken], @"access tokens do not match");
    STAssertTrue([accessGrant.scope isEqualToString:accessGrant2.scope], @"access tokens do not match");
    STAssertTrue([accessGrant.refreshToken isEqualToString:accessGrant2.refreshToken], @"access tokens do not match");
    STAssertEqualsWithAccuracy(accessGrant.expireTime, accessGrant2.expireTime, 0.000001, @"expire times are not equal");

    result = [GHAuthController deleteAccessGrant];
    STAssertTrue(result, @"failed to delete access grant");
    
    OA2AccessGrant *accessGrant3 = [GHAuthController fetchAccessGrant];
    STAssertNil(accessGrant3, @"access should be nil");
}

@end
