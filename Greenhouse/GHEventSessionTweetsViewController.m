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
//  GHEventSessionTweetsViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 9/13/10.
//

#import "GHEventSessionTweetsViewController.h"


@interface GHEventSessionTweetsViewController()

@property (nonatomic, strong) GHEventSession *currentSession;

@end


@implementation GHEventSessionTweetsViewController

@synthesize event;
@synthesize session;
@synthesize currentSession;

#pragma mark -
#pragma mark PullRefreshTableViewController methods

- (void)refreshView
{
	NSString *urlString = [[NSString alloc] initWithFormat:EVENT_SESSION_TWEETS_URL, event.eventId, session.number];
	NSURL *url = [[NSURL alloc] initWithString:urlString];
	self.tweetUrl = url;
	self.tweetViewController.tweetUrl = url;
	
	NSString *tweetText = [[NSString alloc] initWithFormat:@"%@ %@", event.hashtag, session.hashtag];
	self.tweetViewController.tweetText = tweetText;
	
	urlString = [[NSString alloc] initWithFormat:EVENT_SESSION_RETWEET_URL, event.eventId, session.number];
	url = [[NSURL alloc] initWithString:urlString];
	self.retweetUrl = url;
	
	if (![currentSession.number isEqualToString:session.number])
	{
		self.isLoading = YES;
		[self.arrayTweets removeAllObjects];
		[self.tableView reloadData];
	}
	
	self.currentSession = session;
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad
{
	self.lastRefreshKey = @"EventSessionTweetsViewController_LastRefresh";
	
	[super viewDidLoad];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	
	self.event = nil;
	self.session = nil;
	self.currentSession = nil;
}

@end
