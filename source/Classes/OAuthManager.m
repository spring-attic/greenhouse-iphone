//
//  OAuthManager.m
//  Greenhouse
//
//  Created by Roy Clarkson on 6/7/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#define OAUTH_CONSUMER_KEY		@"greenhouse-key"
#define OAUTH_CONSUMER_SECRET	@"s3cr3t"
#define OAUTH_REALM_VALUE		@"Greenhouse"
#define OAUTH_REQUEST_TOKEN_URL	@"http://127.0.0.1:8080/greenhouse/oauth/request_token"
#define OAUTH_AUTHORIZE_URL		@"http://127.0.0.1:8080/greenhouse/oauth/confirm_access"
#define OAUTH_ACCESS_TOKEN_URL	@"http://127.0.0.1:8080/greenhouse/oauth/access_token"
#define OAUTH_CALLBACK_URL		@"x-com-springsource-greenhouse://oauth-response"
//#define TWITTER_UPDATE_URL		@"http://api.twitter.com/1/statuses/update.json"

#define OAUTH_TOKEN				@"oauth_token"
#define OAUTH_TOKEN_SECRET		@"oauth_token_secret"
#define OAUTH_CALLBACK			@"oauth_callback"
#define OAUTH_VERIFIER			@"oauth_verifier"
#define USER_ID					@"user_id"
#define SCREEN_NAME				@"screen_name"
#define TWITTER_STATUS			@"status"


#import "OAuthManager.h"


static OAuthManager *sharedInstance = nil;

@implementation OAuthManager

@dynamic authorized;
@synthesize delegate;
@synthesize selector;


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

- (BOOL)isAuthorized
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:@"authorized"];
}

- (void)setAuthorized:(BOOL)value
{
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:value] forKey:@"authorized"];
}

- (void)fetchUnauthorizedRequestToken;
{
	OAConsumer *consumer = [[OAConsumer alloc] initWithKey:OAUTH_CONSUMER_KEY
													secret:OAUTH_CONSUMER_SECRET];
	
    NSURL *url = [NSURL URLWithString:OAUTH_REQUEST_TOKEN_URL];
	
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url 
																   consumer:consumer 
																	  token:nil   // we don't have a Token yet
																	  realm:OAUTH_REALM_VALUE
														  signatureProvider:nil]; // use the default method, HMAC-SHA1
	
	[consumer release];
	
	[request setHTTPMethod:@"POST"];
	[request setOAuthParameterName:OAUTH_CALLBACK withValue:OAUTH_CALLBACK_URL];
	
	NSLog(@"%@", request);
	
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
		
		NSLog(@"%@", responseBody);
		
		OAToken *requestToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
		[responseBody release];
		
		[[NSUserDefaults standardUserDefaults] setObject:requestToken.key forKey:OAUTH_TOKEN];
		[[NSUserDefaults standardUserDefaults] setObject:requestToken.secret forKey:OAUTH_TOKEN_SECRET];
		
		[self authorizeRequestToken:requestToken];
		[requestToken release];
	}
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	NSLog(@"%@", [error localizedDescription]);
}

- (void)authorizeRequestToken:(OAToken *)requestToken;
{
	[requestToken retain];
	NSString *urlString = [NSString stringWithFormat:@"%@?%@=%@", 
						   OAUTH_AUTHORIZE_URL,
						   OAUTH_TOKEN,
						   requestToken.key];
	
	[requestToken release];
	
	NSLog(@"%@", urlString);
	NSURL *url = [NSURL URLWithString:urlString];
	[[UIApplication sharedApplication] openURL:url];
}

- (void)processOauthResponse:(NSURL *)url
{
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
	
	NSString *oauthToken = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:OAUTH_TOKEN];
	NSString *oauthTokenSecret = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:OAUTH_TOKEN_SECRET];
	
	OAToken *requestToken = [[OAToken alloc] initWithKey:oauthToken secret:oauthTokenSecret];
	
    NSURL *url = [NSURL URLWithString:OAUTH_ACCESS_TOKEN_URL];
	
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url 
																   consumer:consumer 
																	  token:requestToken
																	  realm:OAUTH_REALM_VALUE
														  signatureProvider:nil]; // use the default method, HMAC-SHA1
	
	[consumer release];
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
//		NSString *responseBody = @"oauth_token=b6009bf1-bb5d-47b9-b2a5-f809573235b6&oauth_token_secret=bjcS5tKycNdGRqi2dz%2F0eoLiQBrDCtDYzH%2BisFjkFtu8pqQsd1VKhj89okY6bXccqFO4hTJM%2BfD%2FYUsR7qcJwjd35Y3WpVInHELoU2Zx5O0%3D";
		
		OAToken *accessToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
		[responseBody release];
		
		[accessToken storeInDefaultKeychainWithAppName:@"Greenhouse" serviceProviderName:@"Greenhouse"];
		[accessToken release];
		
		self.authorized = YES;
		
		if ([delegate respondsToSelector:selector])
		{
			[delegate performSelector:selector];
		}		
	}
}

- (void)accessTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	NSLog(@"%@", [error localizedDescription]);
	
	self.authorized = NO;
}

- (void)fetchProfileDetails
{
	OAConsumer *consumer = [[OAConsumer alloc] initWithKey:OAUTH_CONSUMER_KEY
													secret:OAUTH_CONSUMER_SECRET];
		
	OAToken *accessToken = [[OAToken alloc] initWithKeychainUsingAppName:@"Greenhouse" serviceProviderName:@"Greenhouse"];
	
    NSURL *url = [NSURL URLWithString:@"http://localhost:8080/greenhouse/people/@self"];
	
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url 
																   consumer:consumer 
																	  token:accessToken
																	  realm:OAUTH_REALM_VALUE
														  signatureProvider:nil]; // use the default method, HMAC-SHA1
	
	[consumer release];
	[accessToken release];
	
	[request setHTTPMethod:@"GET"];
		
	NSLog(@"%@", request);
	
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
		NSLog(@"%@", responseBody);
		[responseBody release];

		if ([delegate respondsToSelector:selector])
		{
			[delegate performSelector:selector withObject:responseBody];
		}
	}
}

- (void)fetchProfileDetails:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	NSLog(@"%@", [error localizedDescription]);
	
	if ([error code] == NSURLErrorUserCancelledAuthentication)
	{
		[appDelegate showAuthorizeViewController];
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
