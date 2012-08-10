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
//  GHOAuthManager.m
//  Greenhouse
//
//  Created by Roy Clarkson on 6/7/10.
//

#import "GHOAuthManager.h"

#define OAUTH_TOKEN					@"oauth_token"
#define OAUTH_TOKEN_SECRET			@"oauth_token_secret"
#define OAUTH_CALLBACK				@"oauth_callback"
#define OAUTH_VERIFIER				@"oauth_verifier"
#define KEYCHAIN_SERVICE_PROVIDER	@"Greenhouse"


static OAToken *sharedAccessToken = nil;
static OAConsumer *sharedConsumer = nil;

@interface GHOAuthManager()

@property (nonatomic, strong) OAAsynchronousDataFetcher *dataFetcher;
@property (nonatomic, strong) GHActivityAlertView *activityAlertView;

@end


@implementation GHOAuthManager

@synthesize dataFetcher;
@dynamic authorized;
@dynamic accessToken;
@synthesize activityAlertView;


#pragma mark -
#pragma mark Static methods

// Use this class method to obtain the shared instance of the class.
+ (GHOAuthManager *)sharedInstance
{
    static GHOAuthManager *_sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _sharedInstance = [[GHOAuthManager alloc] init];
    });
    return _sharedInstance;
}


#pragma mark -
#pragma mark Instance methods

- (OAToken *)accessToken
{
	if (sharedAccessToken == nil)
	{
		sharedAccessToken = [[OAToken alloc] initWithKeychainUsingAppName:@"Greenhouse" serviceProviderName:KEYCHAIN_SERVICE_PROVIDER];
	}
	
	return sharedAccessToken;
}

- (OAConsumer *)consumer
{
	if (sharedConsumer == nil)
	{
		sharedConsumer = [[OAConsumer alloc] initWithKey:OAUTH_CONSUMER_KEY secret:OAUTH_CONSUMER_SECRET];
	}
	
	return sharedConsumer;
}

- (BOOL)isAuthorized
{
	return (self.accessToken != nil);
}

- (void)removeAccessToken
{
	[self.accessToken removeFromDefaultKeychainWithAppName:@"Greenhouse" serviceProviderName:KEYCHAIN_SERVICE_PROVIDER];
	sharedAccessToken = nil;
}

- (void)cancelDataFetcherRequest
{
	if (dataFetcher)
	{
		DLog(@"");
		
		[dataFetcher cancel];
		self.dataFetcher = nil;
	}
}

- (void)fetchUnauthorizedRequestToken;
{
	self.activityAlertView = [[GHActivityAlertView alloc] initWithActivityMessage:@"Authorizing Greenhouse app..."];
	[activityAlertView startAnimating];
	
	OAConsumer *consumer = [[OAConsumer alloc] initWithKey:OAUTH_CONSUMER_KEY
													secret:OAUTH_CONSUMER_SECRET];
	
    NSURL *url = [NSURL URLWithString:OAUTH_REQUEST_TOKEN_URL];
	
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url 
																   consumer:consumer 
																	  token:nil   // we don't have a Token yet
																	  realm:OAUTH_REALM
														  signatureProvider:nil]; // use the default method, HMAC-SHA1
	
	[request setHTTPMethod:@"POST"];
	[request setOAuthParameterName:OAUTH_CALLBACK withValue:OAUTH_CALLBACK_URL];
	
	DLog(@"%@", request);
	
	[self cancelDataFetcherRequest];
	
	self.dataFetcher = [[OAAsynchronousDataFetcher alloc] initWithRequest:request
															 delegate:self
													didFinishSelector:@selector(requestTokenTicket:didFinishWithData:)
													  didFailSelector:@selector(requestTokenTicket:didFailWithError:)];
	
	[dataFetcher start];
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data 
{
	self.dataFetcher = nil;
	
	[activityAlertView stopAnimating];
	self.activityAlertView = nil;
	
	NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	DLog(@"%@", responseBody);
	
	if (ticket.didSucceed) 
	{
		OAToken *requestToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
		[requestToken storeInDefaultKeychainWithAppName:@"GreenhouseRequestToken" serviceProviderName:KEYCHAIN_SERVICE_PROVIDER];
		[self authorizeRequestToken:requestToken];
	}
	else
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil 
															message:@"A problem occurred while authorizing the app. Please check the availability at greenhouse.springsource.org." 
														   delegate:nil 
												  cancelButtonTitle:@"OK" 
												  otherButtonTitles:nil];
		[alertView show];
	}
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	self.dataFetcher = nil;
	
	[activityAlertView stopAnimating];
	self.activityAlertView = nil;
	
	DLog(@"%@", [error localizedDescription]);
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil 
														message:@"A problem occurred while authorizing the app. Please check the availability at greenhouse.springsource.org." 
													   delegate:nil 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
	[alertView show];
}

- (void)authorizeRequestToken:(OAToken *)requestToken;
{
	NSString *urlString = [NSString stringWithFormat:@"%@?%@=%@", OAUTH_AUTHORIZE_URL, OAUTH_TOKEN, requestToken.key];
	DLog(@"%@", urlString);
	NSURL *url = [NSURL URLWithString:urlString];
	[[UIApplication sharedApplication] openURL:url];
}

- (void)processOauthResponse:(NSURL *)url delegate:(id)aDelegate
{
	delegate = aDelegate;
	NSMutableDictionary* result = [NSMutableDictionary dictionary];
	NSArray *pairs = [[url query] componentsSeparatedByString:@"&"];
	
	for (NSString *pair in pairs) 
	{
		NSRange firstEqual = [pair rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"="]];
		
		if (firstEqual.location == NSNotFound) 
		{
			continue;
		}
		
		NSString *key = [pair substringToIndex:firstEqual.location];
		NSString *value = [pair substringFromIndex:firstEqual.location+1];
		
		[result setObject:[value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
				   forKey:[key stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	}
	
	[self fetchAccessToken:(NSString *)[result objectForKey:OAUTH_VERIFIER]];
}

- (void)fetchAccessToken:(NSString *)oauthVerifier
{
	self.activityAlertView = [[GHActivityAlertView alloc] initWithActivityMessage:nil];
	[activityAlertView startAnimating];
	
	OAConsumer *consumer = [[OAConsumer alloc] initWithKey:OAUTH_CONSUMER_KEY
													secret:OAUTH_CONSUMER_SECRET];
		
	OAToken *requestToken = [[OAToken alloc] initWithKeychainUsingAppName:@"GreenhouseRequestToken" serviceProviderName:KEYCHAIN_SERVICE_PROVIDER];
	
    NSURL *url = [NSURL URLWithString:OAUTH_ACCESS_TOKEN_URL];
	
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url 
																   consumer:consumer 
																	  token:requestToken
																	  realm:OAUTH_REALM
														  signatureProvider:nil]; // use the default method, HMAC-SHA1
	
	[requestToken removeFromDefaultKeychainWithAppName:@"GreenhouseRequestToken" serviceProviderName:KEYCHAIN_SERVICE_PROVIDER];
	[request setHTTPMethod:@"POST"];
	[request setOAuthParameterName:OAUTH_VERIFIER withValue:oauthVerifier];
	
	[self cancelDataFetcherRequest];
	
	self.dataFetcher = [[OAAsynchronousDataFetcher alloc] initWithRequest:request
															 delegate:self
													didFinishSelector:@selector(accessTokenTicket:didFinishWithData:)
													  didFailSelector:@selector(accessTokenTicket:didFailWithError:)];
	
	[dataFetcher start];
}

- (void)accessTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data 
{
	self.dataFetcher = nil;
	
	[activityAlertView stopAnimating];
	self.activityAlertView = nil;
	
	NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	DLog(@"%@", responseBody);
	
	if (ticket.didSucceed)
	{
		OAToken *accessToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];		
		[accessToken storeInDefaultKeychainWithAppName:@"Greenhouse" serviceProviderName:KEYCHAIN_SERVICE_PROVIDER];
	}
	else
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil 
															message:@"A problem occurred while authorizing the app. Please check the availability at greenhouse.springsource.org." 
														   delegate:nil 
												  cancelButtonTitle:@"OK" 
												  otherButtonTitles:nil];
		[alertView show];
	}
	
    [delegate processOAuthResponseDidFinish];
}

- (void)accessTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	self.dataFetcher = nil;
	
	DLog(@"%@", [error localizedDescription]);
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil 
														message:@"A problem occurred while authorizing the app. Please check the availability at greenhouse.springsource.org." 
													   delegate:nil 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
	[alertView show];
    
	[delegate processOAuthResponseDidFail];
}

@end
