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

#define GREENHOUSE_URL							@"http://127.0.0.1:8080/greenhouse"


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
#define MEMBER_PROFILE_PICTURE_URL				[NSString stringWithFormat:@"%@%@", GREENHOUSE_URL, @"/members/%i/picture?"]
#define MEMBER_PROFILE_SMALL_PICTURE_URL		[NSString stringWithFormat:@"%@%@", GREENHOUSE_URL, @"/members/%i/picture?type=small"]
#define MEMBER_PROFILE_LARGE_PICTURE_URL		[NSString stringWithFormat:@"%@%@", GREENHOUSE_URL, @"/members/%i/picture?type=large"]


#pragma mark -
#pragma mark Events

#define EVENTS_URL								[NSString stringWithFormat:@"%@%@", GREENHOUSE_URL, @"/events/"]
#define EVENT_SESSIONS_CURRENT_URL				[NSString stringWithFormat:@"%@%@", GREENHOUSE_URL, @"/events/%i/sessions/today"]
#define EVENT_SESSIONS_FAVORITES_URL			[NSString stringWithFormat:@"%@%@", GREENHOUSE_URL, @"/events/%i/sessions/favorites"]
#define EVENT_SESSIONS_CONFERENCE_FAVORITES_URL	[NSString stringWithFormat:@"%@%@", GREENHOUSE_URL, @"/events/%i/favorites"]
#define EVENT_SESSIONS_FAVORITE_URL				[NSString stringWithFormat:@"%@%@", GREENHOUSE_URL, @"/events/%i/sessions/%i/favorite"]
#define EVENT_SESSIONS_BY_DAY_URL				[NSString stringWithFormat:@"%@%@", GREENHOUSE_URL, @"/events/%i/sessions/%@"]
#define EVENT_TWEETS_URL						[NSString stringWithFormat:@"%@%@", GREENHOUSE_URL, @"/events/%i/tweets"]
#define EVENT_RETWEET_URL						[NSString stringWithFormat:@"%@%@", GREENHOUSE_URL, @"/events/%i/retweet"]
#define EVENT_SESSION_TWEETS_URL				[NSString stringWithFormat:@"%@%@", GREENHOUSE_URL, @"/events/%i/sessions/%i/tweets"]
#define EVENT_SESSION_RETWEET_URL				[NSString stringWithFormat:@"%@%@", GREENHOUSE_URL, @"/events/%i/sessions/%i/retweet"]
#define EVENT_SESSION_RATING_URL				[NSString stringWithFormat:@"%@%@", GREENHOUSE_URL, @"/events/%i/sessions/%i/rating"]
#define EVENT_LOCATION_MAP_URL					@"http://maps.google.com/maps/api/geocode/json?address=%@&sensor=true"


#pragma mark -
#pragma mark Updates

#define UPDATES_URL								[NSString stringWithFormat:@"%@%@", GREENHOUSE_URL, @"/greenhouse/updates/"]