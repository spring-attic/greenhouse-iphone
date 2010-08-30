//
//  UserSettings.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/25/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "UserSettings.h"


#define includeLocationInTweetPreference @"include_location_in_tweets_preference"


static UserSettings *sharedInstance = nil;

@implementation UserSettings

@dynamic includeLocationInTweet;


#pragma mark -
#pragma mark Static methods

// This class is configured to function as a singleton. 
// Use this class method to obtain the shared instance of the class.
+ (UserSettings *)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
		{
			sharedInstance = [[UserSettings alloc] init];
		}
    }
	
    return sharedInstance;
}


#pragma mark -
#pragma mark Instance methods

- (BOOL)includeLocationInTweet
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:includeLocationInTweetPreference];
}

- (void)setIncludeLocationInTweet:(BOOL)boolVal
{
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:boolVal] forKey:includeLocationInTweetPreference];
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


