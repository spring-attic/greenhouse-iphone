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
//  GHUserSettings.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/25/10.
//

#import "GHUserSettings.h"


#define includeLocationInTweetPreference	@"include_location_in_tweets_preference"
#define resetAppOnStartPreference			@"reset_app_on_start_preference"
#define dataExpirationPreference			@"data_expiration_preference"
#define versionPreference					@"version_preference"


@implementation GHUserSettings

+ (void)reset
{
	[[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
	[[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:resetAppOnStartPreference];
}

+ (BOOL)includeLocationInTweet
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:includeLocationInTweetPreference];
}

+ (void)setIncludeLocationInTweet:(BOOL)boolVal
{
	[[NSUserDefaults standardUserDefaults] setObject:@(boolVal) forKey:includeLocationInTweetPreference];
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
