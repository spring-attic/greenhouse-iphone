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
//  GHAuthController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/14/12.
//

#define KEYCHAIN_SERVICE_NAME    @"Greenhouse"
#define KEYCHAIN_ACCOUNT_NAME    @"OAuth2"

#import "GHAuthController.h"
#import "OA2AccessGrant.h"
#import "GHSignUpForm.h"
#import "OA2SignInRequestParameters.h"
#import "GHURLPostRequest.h"
#import "GHKeychainManager.h"
#import "GHConnectionSettings.h"

@implementation GHAuthController


#pragma mark -
#pragma mark Static methods

// Use this class method to obtain the shared instance of the class.
+ (GHAuthController *)sharedInstance
{
    static GHAuthController *_sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _sharedInstance = [[GHAuthController alloc] init];
    });
    return _sharedInstance;
}

+ (BOOL)isAuthorized
{
    OA2AccessGrant *accessGrant = [self fetchAccessGrant];
    return (accessGrant != nil);
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


#pragma mark -
#pragma mark Instance methods

- (void)sendRequestToSignIn:(NSString *)username password:(NSString *)password delegate:(id<GHAuthControllerDelegate>)delegate
{
    OA2SignInRequestParameters *parameters = [[OA2SignInRequestParameters alloc] initWithUsername:username password:password];
    NSURL *url = [GHConnectionSettings urlWithFormat:@"/oauth/token"];
    NSURLRequest *request = [[GHURLPostRequest alloc] initWithURL:url parameters:parameters];
    DLog(@"%@", request);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];         
         NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
         if (statusCode == 200 && data.length > 0 && error == nil)
         {
             DLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
             NSError *errorInternal;
             OA2AccessGrant *accessGrant = [[OA2AccessGrant alloc] initWithData:data error:&errorInternal];
             if (!errorInternal)
             {
                 [GHAuthController storeAccessGrant:accessGrant];
             }
             else
             {
                 DLog(@"error parsing access grant: %@", [errorInternal localizedDescription]);
             }
             dispatch_sync(dispatch_get_main_queue(), ^{
                 [delegate authRequestDidSucceed];
             });
         }
         else if (error)
         {
             DLog(@"%d - %@", [error code], [error localizedDescription]);
             NSString *msg;
             switch ([error code]) {
                 case NSURLErrorUserCancelledAuthentication:
                     msg = @"Your email or password was entered incorrectly.";
                     break;
                 case NSURLErrorCannotConnectToHost:
                     msg = @"The server is unavailable. Please try again in a few minutes.";
                     break;
                 default:
                     msg = @"A problem occurred with the network connection. Please try again in a few minutes.";
                     break;
             }
             dispatch_sync(dispatch_get_main_queue(), ^{
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                 message:msg
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
                 [alert show];
                 [delegate authRequestDidFailWithError:error];
             });
         }
         else if (statusCode != 200)
         {
             DLog(@"HTTP Status Code: %d", statusCode);
             NSString *msg;
             switch (statusCode) {
                 default:
                     msg = @"You cannot be signed in.";
                     break;
             }
             dispatch_sync(dispatch_get_main_queue(), ^{
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                     message:msg
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 [delegate authRequestDidFailWithError:error];
             });
         }
     }];
}

- (void)sendRequestToSignUp:(GHSignUpForm *)signUpForm delegate:(id<GHAuthControllerDelegate>)delegate
{
    NSURL *url = [GHConnectionSettings urlWithFormat:@"/signup"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[signUpForm dictionaryValue] options:0 error:nil];
    DLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
	NSString *postLength = [NSString stringWithFormat:@"%d", [jsonData length]];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:jsonData];
    DLog(@"%@", request);
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
         DLog(@"status code: %d", statusCode);
         DLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
         if (statusCode == 201 && data.length > 0 && error == nil)
         {
             // account successfully created, so now sign in
             [self sendRequestToSignIn:signUpForm.email password:signUpForm.password delegate:delegate];
         }
         else if (statusCode == 400 && data.length > 0)
         {
             // errors creating account
             
             NSError *errorInternal;
             NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&errorInternal];
             if (!errorInternal)
             {
                 NSString *title = [dictionary stringForKey:@"message"];
                 NSArray *validationErrors = [dictionary objectForKey:@"errors"];
                 NSMutableArray *messages = [[NSMutableArray alloc] init];
                 [validationErrors enumerateObjectsUsingBlock:^(NSDictionary *validationError, NSUInteger idx, BOOL *stop) {
                     [messages addObject:[[NSString alloc] initWithFormat:@"- %@ %@",
                                          [validationError stringForKey:@"field"],
                                          [validationError stringForKey:@"message"]]];
                 }];
                 NSString *message = [messages componentsJoinedByString:@"\n"];
                 
                 dispatch_sync(dispatch_get_main_queue(), ^{
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                                     message:message
                                                                    delegate:@""
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
                     [alert show];
                     [delegate authRequestDidFailWithError:error];
                 });
             }
             else
             {
                 dispatch_sync(dispatch_get_main_queue(), ^{
                     [delegate authRequestDidFailWithError:error];
                 });
             }
         }
         else
         {
             if (error)
             {
                 DLog(@"%d - %@", [error code], [error localizedDescription]);
             }
             
             dispatch_sync(dispatch_get_main_queue(), ^{
                 [delegate authRequestDidFailWithError:error];
             });
         }
     }];
}

@end
