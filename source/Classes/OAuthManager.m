//
//  OAuthManager.m
//  Greenhouse
//
//  Created by Roy Clarkson on 6/7/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#define OAUTH_CONSUMER_KEY		@"a08318eb478a1ee31f69a55276f3af64"
#define OAUTH_CONSUMER_SECRET	@"80e7f8f7ba724aae9103f297e5fb9bdf"
#define OAUTH_REALM				@"Greenhouse"
#define OAUTH_REQUEST_TOKEN_URL	@"http://127.0.0.1:8080/greenhouse/oauth/request_token"
#define OAUTH_AUTHORIZE_URL		@"http://127.0.0.1:8080/greenhouse/oauth/confirm_access"
#define OAUTH_ACCESS_TOKEN_URL	@"http://127.0.0.1:8080/greenhouse/oauth/access_token"
#define OAUTH_CALLBACK_URL		@"x-com-springsource-greenhouse://oauth-response"
#define OAUTH_TOKEN				@"oauth_token"
#define OAUTH_TOKEN_SECRET		@"oauth_token_secret"
#define OAUTH_CALLBACK			@"oauth_callback"
#define OAUTH_VERIFIER			@"oauth_verifier"
#define MEMBER_PROFILE_URL		@"http://127.0.0.1:8080/greenhouse/members/@self"


#import "OAuthManager.h"


static OAuthManager *sharedInstance = nil;
static OAToken *authorizedAccessToken = nil;

@implementation OAuthManager

@dynamic authorized;
@dynamic accessToken;


#pragma mark -
#pragma mark Class methods

// This class is configured to function as a singleton. 
// Use this class method to obtain the shared instance of the class.
+ (OAuthManager *)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
		{
			sharedInstance = [[OAuthManager alloc] init];
		}
    }
	
    return sharedInstance;
}


#pragma mark -
#pragma mark Public methods

- (OAToken *)accessToken
{
	if (authorizedAccessToken == nil)
	{
		authorizedAccessToken = [[OAToken alloc] initWithKeychainUsingAppName:@"Greenhouse" serviceProviderName:@"Greenhouse"];
	}
	
	return authorizedAccessToken;
}

- (BOOL)isAuthorized
{
	return (self.accessToken != nil);
}

- (void)removeAccessToken
{
	[self.accessToken removeFromDefaultKeychainWithAppName:@"Greenhouse" serviceProviderName:@"Greenhouse"];
	authorizedAccessToken = nil;
}

- (void)fetchUnauthorizedRequestToken;
{
	OAConsumer *consumer = [[OAConsumer alloc] initWithKey:OAUTH_CONSUMER_KEY
													secret:OAUTH_CONSUMER_SECRET];
	
    NSURL *url = [NSURL URLWithString:OAUTH_REQUEST_TOKEN_URL];
	
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url 
																   consumer:consumer 
																	  token:nil   // we don't have a Token yet
																	  realm:OAUTH_REALM
														  signatureProvider:nil]; // use the default method, HMAC-SHA1
	
	[consumer release];
	
	[request setHTTPMethod:@"POST"];
	[request setOAuthParameterName:OAUTH_CALLBACK withValue:OAUTH_CALLBACK_URL];
	
	DLog(@"%@", request);
	
	OADataFetcher *fetcher = [[OADataFetcher alloc] init];
	
	[fetcher fetchDataWithRequest:request
						 delegate:self
				didFinishSelector:@selector(requestTokenTicket:didFinishWithData:)
				  didFailSelector:@selector(requestTokenTicket:didFailWithError:)];
	
	[request release];
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data 
{
	if (ticket.didSucceed) 
	{
		NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		
		DLog(@"%@", responseBody);
		
		OAToken *requestToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
		[responseBody release];
		
		[requestToken storeInDefaultKeychainWithAppName:@"GreenhouseRequestToken" serviceProviderName:@"Greenhouse"];
		
		[self authorizeRequestToken:requestToken];
		[requestToken release];
	}
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	DLog(@"%@", [error localizedDescription]);
}

- (void)authorizeRequestToken:(OAToken *)requestToken;
{
	[requestToken retain];
	NSString *urlString = [NSString stringWithFormat:@"%@?%@=%@", 
						   OAUTH_AUTHORIZE_URL,
						   OAUTH_TOKEN,
						   requestToken.key];
	
	[requestToken release];
	
	DLog(@"%@", urlString);
	NSURL *url = [NSURL URLWithString:urlString];
	[[UIApplication sharedApplication] openURL:url];
}

- (void)processOauthResponse:(NSURL *)url delegate:(id)aDelegate didFinishSelector:(SEL)finishSelector didFailSelector:(SEL)failSelector
{
	delegate = aDelegate;
	didFinishSelector = finishSelector;
	didFailSelector = failSelector;
	
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
	OAConsumer *consumer = [[OAConsumer alloc] initWithKey:OAUTH_CONSUMER_KEY
													secret:OAUTH_CONSUMER_SECRET];
		
	OAToken *requestToken = [[OAToken alloc] initWithKeychainUsingAppName:@"GreenhouseRequestToken" serviceProviderName:@"Greenhouse"];
	
    NSURL *url = [NSURL URLWithString:OAUTH_ACCESS_TOKEN_URL];
	
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url 
																   consumer:consumer 
																	  token:requestToken
																	  realm:OAUTH_REALM
														  signatureProvider:nil]; // use the default method, HMAC-SHA1
	
	[consumer release];
	[requestToken removeFromDefaultKeychainWithAppName:@"GreenhouseRequestToken" serviceProviderName:@"Greenhouse"];
	[requestToken release];
	
	[request setHTTPMethod:@"POST"];
	[request setOAuthParameterName:OAUTH_VERIFIER withValue:oauthVerifier];
	
	OADataFetcher *fetcher = [[OADataFetcher alloc] init];
	
	[fetcher fetchDataWithRequest:request
						 delegate:self
				didFinishSelector:@selector(accessTokenTicket:didFinishWithData:)
				  didFailSelector:@selector(accessTokenTicket:didFailWithError:)];
	
	[request release];
}

- (void)accessTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data 
{
	if (ticket.didSucceed)
	{
		NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		
		OAToken *accessToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
		[responseBody release];
		
		[accessToken storeInDefaultKeychainWithAppName:@"Greenhouse" serviceProviderName:@"Greenhouse"];
		[accessToken release];
		
		if ([delegate respondsToSelector:didFinishSelector])
		{
			[delegate performSelector:didFinishSelector];
		}		
	}
}

- (void)accessTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	DLog(@"%@", [error localizedDescription]);
	
	if ([delegate respondsToSelector:didFailSelector])
	{
		[delegate performSelector:didFailSelector];
	}	
}

- (void)fetchProfileDetailsWithDelegate:(id)aDelegate didFinishSelector:(SEL)finishSelector didFailSelector:(SEL)failSelector
{
	delegate = aDelegate;
	didFinishSelector = finishSelector;
	didFailSelector = failSelector;
	
	OAConsumer *consumer = [[OAConsumer alloc] initWithKey:OAUTH_CONSUMER_KEY
													secret:OAUTH_CONSUMER_SECRET];
		
    NSURL *url = [NSURL URLWithString:MEMBER_PROFILE_URL];
	
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url 
																   consumer:consumer 
																	  token:self.accessToken
																	  realm:OAUTH_REALM
														  signatureProvider:nil]; // use the default method, HMAC-SHA1
	
	[consumer release];
	
	[request setHTTPMethod:@"GET"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
		
	DLog(@"%@", request);
	
	OADataFetcher *fetcher = [[OADataFetcher alloc] init];
	
	[fetcher fetchDataWithRequest:request
						 delegate:self
				didFinishSelector:@selector(fetchProfileDetails:didFinishWithData:)
				  didFailSelector:@selector(fetchProfileDetails:didFailWithError:)];
	
	[request release];
}

- (void)fetchProfileDetails:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	if (ticket.didSucceed) 
	{
		NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		DLog(@"%@", responseBody);

		if ([delegate respondsToSelector:didFinishSelector])
		{
			[delegate performSelector:didFinishSelector withObject:responseBody];
		}
		
		[responseBody release];
	}
}

- (void)fetchProfileDetails:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	DLog(@"%@", [error localizedDescription]);
	
	if ([delegate respondsToSelector:didFailSelector]) 
	{
		[delegate performSelector:didFailSelector withObject:error];
	}
}

- (void)fetchUpdatesWithDelegate:(id)aDelegate didFinishSelector:(SEL)finishSelector didFailSelector:(SEL)failSelector
{
	delegate = aDelegate;
	didFinishSelector = finishSelector;
	didFailSelector = failSelector;
	
	OAConsumer *consumer = [[OAConsumer alloc] initWithKey:OAUTH_CONSUMER_KEY
													secret:OAUTH_CONSUMER_SECRET];
	
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1:8080/greenhouse/updates"];
	
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url 
																   consumer:consumer 
																	  token:self.accessToken
																	  realm:OAUTH_REALM
														  signatureProvider:nil]; // use the default method, HMAC-SHA1
	
	[consumer release];
	
	[request setHTTPMethod:@"GET"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	
	DLog(@"%@", request);
	
	OADataFetcher *fetcher = [[OADataFetcher alloc] init];
	
	[fetcher fetchDataWithRequest:request
						 delegate:self
				didFinishSelector:@selector(fetchUpdates:didFinishWithData:)
				  didFailSelector:@selector(fetchUpdates:didFailWithError:)];
	
	[request release];
}

- (void)fetchUpdates:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	if (ticket.didSucceed) 
	{
		NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		DLog(@"%@", responseBody);
		
		if ([delegate respondsToSelector:didFinishSelector])
		{
			[delegate performSelector:didFinishSelector withObject:responseBody];
		}
		
		[responseBody release];
	}
}

- (void)fetchUpdates:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	DLog(@"%@", [error localizedDescription]);
	
	if ([delegate respondsToSelector:didFailSelector]) 
	{
		[delegate performSelector:didFailSelector withObject:error];
	}
}

- (void)fetchEventsWithDelegate:(id)aDelegate didFinishSelector:(SEL)finishSelector didFailSelector:(SEL)failSelector
{
	delegate = aDelegate;
	didFinishSelector = finishSelector;
	didFailSelector = failSelector;
	
	OAConsumer *consumer = [[OAConsumer alloc] initWithKey:OAUTH_CONSUMER_KEY
													secret:OAUTH_CONSUMER_SECRET];
	
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1:8080/greenhouse/events"];
	
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url 
																   consumer:consumer 
																	  token:self.accessToken
																	  realm:OAUTH_REALM
														  signatureProvider:nil]; // use the default method, HMAC-SHA1
	
	[consumer release];
	
	[request setHTTPMethod:@"GET"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	
	DLog(@"%@", request);
	
	OADataFetcher *fetcher = [[OADataFetcher alloc] init];
	
	[fetcher fetchDataWithRequest:request
						 delegate:self
				didFinishSelector:@selector(fetchEvents:didFinishWithData:)
				  didFailSelector:@selector(fetchEvents:didFailWithError:)];
	
	[request release];
}

- (void)fetchEvents:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	if (ticket.didSucceed) 
	{
		NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		DLog(@"%@", responseBody);
		
		if ([delegate respondsToSelector:didFinishSelector])
		{
			[delegate performSelector:didFinishSelector withObject:responseBody];
		}
		
		[responseBody release];
	}
}

- (void)fetchEvents:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	DLog(@"%@", [error localizedDescription]);
	
	if ([delegate respondsToSelector:didFailSelector]) 
	{
		[delegate performSelector:didFailSelector withObject:error];
	}
}

- (void)fetchTweetsWithEventId:(NSInteger)eventId delegate:(id)aDelegate didFinishSelector:(SEL)finishSelector didFailSelector:(SEL)failSelector
{
	delegate = aDelegate;
	didFinishSelector = finishSelector;
	didFailSelector = failSelector;
	
	OAConsumer *consumer = [[OAConsumer alloc] initWithKey:OAUTH_CONSUMER_KEY
													secret:OAUTH_CONSUMER_SECRET];
	
	NSString *urlString = [NSString stringWithFormat:@"http://127.0.0.1:8080/greenhouse/events/%i/tweets", eventId];	
    NSURL *url = [NSURL URLWithString:urlString];
	
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url 
																   consumer:consumer 
																	  token:self.accessToken
																	  realm:OAUTH_REALM
														  signatureProvider:nil]; // use the default method, HMAC-SHA1
	
	[consumer release];
	
	[request setHTTPMethod:@"GET"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	
	DLog(@"%@", request);
	
	OADataFetcher *fetcher = [[OADataFetcher alloc] init];
	
	[fetcher fetchDataWithRequest:request
						 delegate:self
				didFinishSelector:@selector(fetchTweets:didFinishWithData:)
				  didFailSelector:@selector(fetchTweets:didFailWithError:)];
	
	[request release];
}

- (void)fetchTweets:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	if (ticket.didSucceed) 
	{
		NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		DLog(@"%@", responseBody);
		
		if ([delegate respondsToSelector:didFinishSelector])
		{
			[delegate performSelector:didFinishSelector withObject:responseBody];
		}
		
		[responseBody release];
	}
}

- (void)fetchTweets:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	DLog(@"%@", [error localizedDescription]);
	
	if ([delegate respondsToSelector:didFailSelector]) 
	{
		[delegate performSelector:didFailSelector withObject:error];
	}
}


#pragma mark -
#pragma mark NSObject methods

+ (id)allocWithZone:(NSZone *)zone 
{
    @synchronized(self) 
	{
        if (sharedInstance == nil) 
		{
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
	
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain 
{
    return self;
}

- (unsigned)retainCount 
{
    return UINT_MAX;  // denotes an object that cannot be released
}

- (oneway void)release 
{
    //do nothing
}

- (id)autorelease 
{
    return self;
}

@end
