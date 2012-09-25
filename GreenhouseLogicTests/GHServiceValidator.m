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
//  GHServiceValidator.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/21/12.
//

#import <Foundation/Foundation.h>
#import "GHServiceValidator.h"
#import "GHAuthController.h"
#import "OA2AccessGrant.h"
#import "OA2SignInRequest.h"
#import "OA2AuthorizedRequest.h"

@implementation GHServiceValidator


#pragma mark -
#pragma mark Test methods

- (void)testSignInRequestManual
{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            @"password", @"grant_type",
                            @"habuma", @"username",
                            @"freebird", @"password",
                            @"testclient", @"client_id",
                            @"testsecret", @"client_secret",
                            @"read,write", @"scope",
                            nil];

    NSMutableArray *array = [[NSMutableArray alloc] init];
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [array addObject:[NSString stringWithFormat:@"%@=%@", [self URLEncodeString:key], [self URLEncodeString:obj]]];
    }];
    NSString *parameters = [array componentsJoinedByString:@"&"];
    
    NSData *postData = [parameters dataUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1:8080/greenhouse/oauth/token"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%ui", postData.length] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    

    NSURLResponse *response;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSLog(@"%i %@", [httpResponse statusCode], [NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]);
    
    if (data.length > 0 && error == nil)
    {
        OA2AccessGrant *accessGrant = [[OA2AccessGrant alloc] initWithData:data error:NULL];
        STAssertFalse([accessGrant.accessToken isEqualToString:@""] || accessGrant.accessToken == nil, @"empty access token");
    }
    else if (data.length == 0 && error == nil)
    {
        STFail(@"empty response");
    }
    else if (error != nil)
    {
        STFail([error localizedDescription]);
    }    
}

- (void)testFetchEvents
{
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1:8080/greenhouse/oauth/token"];
    NSURLRequest *request = [[OA2SignInRequest alloc] initWithURL:url username:@"rclarkson" password:@"atlanta"];
    NSURLResponse *response;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSLog(@"%i %@", [httpResponse statusCode], [NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]);
    
    OA2AccessGrant *accessGrant = nil;
    if (data.length > 0 && error == nil)
    {
        accessGrant = [[OA2AccessGrant alloc] initWithData:data error:NULL];
        STAssertFalse([accessGrant.accessToken isEqualToString:@""] || accessGrant.accessToken == nil, @"empty access token");
    }
    else if (data.length == 0 && error == nil)
    {
        STFail(@"empty response");
    }
    else if (error != nil)
    {
        STFail([error localizedDescription]);
    }
    
    url = [NSURL URLWithString:@"http://127.0.0.1:8080/greenhouse/events"];
    request = [[OA2AuthorizedRequest alloc] initWithURL:url accessToken:accessGrant.accessToken];
    error = nil;
    data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    httpResponse = (NSHTTPURLResponse*)response;
    NSLog(@"%i %@", [httpResponse statusCode], [NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]);
    
    if (data.length > 0 && error == nil)
    {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        NSString *title = [[array objectAtIndex:0] objectForKey:@"title"];
        STAssertNotNil(title, @"should have a title");
    }
    else if (data.length == 0 && error == nil)
    {
        STFail(@"empty response");
    }
    else if (error != nil)
    {
        STFail([error localizedDescription]);
    }
}


#pragma mark -
#pragma mark Helper methods

- (NSString *)URLEncodeString:(NSString *)string
{
    NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                             (__bridge CFStringRef)string,
                                                                                             NULL,
                                                                                             CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                             kCFStringEncodingUTF8);
	return result;
}

@end
