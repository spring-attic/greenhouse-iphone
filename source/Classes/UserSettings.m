//
//  UserSettings.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/25/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "UserSettings.h"


#define includeLocationInTweetPreference	@"include_location_in_tweets_preference"
#define resetAppOnStartPreference			@"reset_app_on_start_preference"
#define dataExpirationPreference			@"data_expiration_preference"
#define versionPreference					@"version_preference"


@implementation UserSettings

+ (void)reset
{
	[[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:resetAppOnStartPreference];
}

+ (BOOL)includeLocationInTweet
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:includeLocationInTweetPreference];
}

+ (void)setIncludeLocationInTweet:(BOOL)boolVal
{
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:boolVal] forKey:includeLocationInTweetPreference];
}

+ (NSInteger)dataExpiration
{
	[[NSUserDefaults standardUserDefaults] synchronize];
	NSString *s = [[NSUserDefaults standardUserDefaults] stringForKey:dataExpirationPreference];
	DLog(@"%@", s);
	
	if (s)
	{
		return [s intValue];
	}
	else 
	{
		// default of 4 hours
		return 14400;
	}
}

+ (BOOL)resetAppOnStart
{
	[[NSUserDefaults standardUserDefaults] synchronize];
	return [[NSUserDefaults standardUserDefaults] boolForKey:resetAppOnStartPreference];
}

+ (void)setAppVersion:(NSString *)appVersion
{	
	[[NSUserDefaults standardUserDefaults] setObject:appVersion forKey:versionPreference];	
}

@end
