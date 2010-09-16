//
//  Constants.h
//  Greenhouse
//
//  Created by Roy Clarkson on 6/14/10.
//  Copyright 2010 VMware. All rights reserved.
//

#define appDelegate (GreenhouseAppDelegate *)[[UIApplication sharedApplication] delegate]

#pragma mark -
#pragma mark Web Service

#if LOCALHOST

	#define GREENHOUSE_URL							@"http://127.0.0.1:8080/greenhouse"

#elif QA

	#define GREENHOUSE_URL							@"http://greenhouse.springsource.org"

#elif PRODUCTION

	#define GREENHOUSE_URL							@"http://greenhouse.springsource.org"

#endif


#pragma mark -
#pragma mark OAuth

#define OAUTH_CONSUMER_KEY						@"a08318eb478a1ee31f69a55276f3af64"
#define OAUTH_CONSUMER_SECRET					@"80e7f8f7ba724aae9103f297e5fb9bdf"
#define OAUTH_REALM								@"Greenhouse"
#define OAUTH_REQUEST_TOKEN_URL					[NSString stringWithFormat:@"%@%@", GREENHOUSE_URL, @"/oauth/request_token"]
#define OAUTH_AUTHORIZE_URL						[NSString stringWithFormat:@"%@%@", GREENHOUSE_URL, @"/oauth/confirm_access"]
#define OAUTH_ACCESS_TOKEN_URL					[NSString stringWithFormat:@"%@%@", GREENHOUSE_URL, @"/oauth/access_token"]
#define OAUTH_CALLBACK_URL						@"x-com-springsource-greenhouse://oauth-response"


#pragma mark -
#pragma mark Member Profile

#define MEMBER_PROFILE_URL						[NSString stringWithFormat:@"%@%@", GREENHOUSE_URL, @"/members/@self"]


#pragma mark -
#pragma mark Events

#define EVENTS_URL								[NSString stringWithFormat:@"%@%@", GREENHOUSE_URL, @"/events/"]
#define EVENT_SESSIONS_CURRENT_URL				[NSString stringWithFormat:@"%@%@", GREENHOUSE_URL, @"/events/%@/sessions/today"]
#define EVENT_SESSIONS_FAVORITES_URL			[NSString stringWithFormat:@"%@%@", GREENHOUSE_URL, @"/events/%@/sessions/favorites"]
#define EVENT_SESSIONS_CONFERENCE_FAVORITES_URL	[NSString stringWithFormat:@"%@%@", GREENHOUSE_URL, @"/events/%@/favorites"]
#define EVENT_SESSIONS_FAVORITE_URL				[NSString stringWithFormat:@"%@%@", GREENHOUSE_URL, @"/events/%@/sessions/%@/favorite"]
#define EVENT_SESSIONS_BY_DAY_URL				[NSString stringWithFormat:@"%@%@", GREENHOUSE_URL, @"/events/%@/sessions/%@"]
#define EVENT_TWEETS_URL						[NSString stringWithFormat:@"%@%@", GREENHOUSE_URL, @"/events/%@/tweets"]
#define EVENT_RETWEET_URL						[NSString stringWithFormat:@"%@%@", GREENHOUSE_URL, @"/events/%@/retweet"]
#define EVENT_SESSION_TWEETS_URL				[NSString stringWithFormat:@"%@%@", GREENHOUSE_URL, @"/events/%@/sessions/%@/tweets"]
#define EVENT_SESSION_RETWEET_URL				[NSString stringWithFormat:@"%@%@", GREENHOUSE_URL, @"/events/%@/sessions/%@/retweet"]
#define EVENT_SESSION_RATING_URL				[NSString stringWithFormat:@"%@%@", GREENHOUSE_URL, @"/events/%@/sessions/%@/rating"]
#define EVENT_LOCATION_MAP_URL					@"http://maps.google.com/maps/api/geocode/json?address=%@&sensor=true"


#pragma mark -
#pragma mark Updates

#define UPDATES_URL								[NSString stringWithFormat:@"%@%@", GREENHOUSE_URL, @"/greenhouse/updates/"]