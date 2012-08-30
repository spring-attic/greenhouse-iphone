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
//  GHKeychainManagerTests.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/24/12.
//

#define KEYCHAIN_SERVICE_NAME   @"GHApplicationTests"
#define TEST_PASSWORD_DATA      @"test123"

#import "GHKeychainManagerTests.h"
#import "GHKeychainManager.h"

@implementation GHKeychainManagerTests


#pragma mark -
#pragma mark SentestCase methods

- (void)setUp
{
    [super setUp];
    
    // delete existing test keychain items
    NSDictionary *query = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                           (__bridge id)kSecClassGenericPassword, (__bridge id)kSecClass,
                           KEYCHAIN_SERVICE_NAME, (__bridge id)kSecAttrService,
                           nil];
	SecItemDelete((__bridge CFDictionaryRef)query);
}

- (void)tearDown
{
    // delete test keychain items
    NSDictionary *query = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                           (__bridge id)kSecClassGenericPassword, (__bridge id)kSecClass,
                           KEYCHAIN_SERVICE_NAME, (__bridge id)kSecAttrService,
                           nil];
	SecItemDelete((__bridge CFDictionaryRef)query);
    
    [super tearDown];
}


#pragma mark -
#pragma mark Test methods

- (void)testStorePassword
{
    NSData *passwordData;
    OSStatus status = [[GHKeychainManager sharedInstance] fetchPassword:&passwordData service:KEYCHAIN_SERVICE_NAME account:@"testDeletePassword"];
    STAssertTrue(status == errSecItemNotFound, @"password should not be found");
    STAssertNil(passwordData, @"password should not be found");
    
    NSData *data = [TEST_PASSWORD_DATA dataUsingEncoding:NSUTF8StringEncoding];
    status = [[GHKeychainManager sharedInstance] storePassword:data service:KEYCHAIN_SERVICE_NAME account:@"testStorePassword"];
    STAssertTrue(status == errSecSuccess, @"error storing password");
}

- (void)testFetchPassword
{
    NSData *data = [TEST_PASSWORD_DATA dataUsingEncoding:NSUTF8StringEncoding];
    OSStatus status = [[GHKeychainManager sharedInstance] storePassword:data service:KEYCHAIN_SERVICE_NAME account:@"testFetchPassword"];
    STAssertTrue(status == errSecSuccess, @"error storing password");
    
    NSData *passwordData;
    status = [[GHKeychainManager sharedInstance] fetchPassword:&passwordData service:KEYCHAIN_SERVICE_NAME account:@"testFetchPassword"];
    STAssertTrue(status == errSecSuccess, @"error fetching password");
    STAssertTrue([TEST_PASSWORD_DATA isEqualToString:[[NSString alloc] initWithData:passwordData encoding:NSUTF8StringEncoding]], @"passwords do not match");
}

- (void)testDeletePassword
{
    NSData *data = [TEST_PASSWORD_DATA dataUsingEncoding:NSUTF8StringEncoding];
    OSStatus status = [[GHKeychainManager sharedInstance] storePassword:data service:KEYCHAIN_SERVICE_NAME account:@"testDeletePassword"];
    STAssertTrue(status == errSecSuccess, @"error storing password");
    
    status = [[GHKeychainManager sharedInstance] deletePasswordWithService:KEYCHAIN_SERVICE_NAME account:@"testDeletePassword"];
    STAssertTrue(status == errSecSuccess, @"error deleting password");
    
    NSData *passwordData;
    status = [[GHKeychainManager sharedInstance] fetchPassword:&passwordData service:KEYCHAIN_SERVICE_NAME account:@"testDeletePassword"];
    STAssertTrue(status == errSecItemNotFound, @"password should not be found");
    STAssertNil(passwordData, @"password should not be found");
}

@end
