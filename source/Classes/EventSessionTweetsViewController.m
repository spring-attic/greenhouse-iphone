//
//  EventSessionTweetsViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 9/13/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "EventSessionTweetsViewController.h"


@interface EventSessionTweetsViewController()

@property (nonatomic, retain) EventSession *currentSession;

@end



@implementation EventSessionTweetsViewController

@synthesize event;
@synthesize session;
@synthesize currentSession;

#pragma mark -
#pragma mark PullRefreshTableViewController methods

- (void)refreshView
{
	NSString *urlString = [[NSString alloc] initWithFormat:EVENT_SESSION_TWEETS_URL, event.eventId, session.number];
	NSURL *url = [[NSURL alloc] initWithString:urlString];
	[urlString release];
	self.tweetUrl = url;
	[url release];
	
	self.newTweetViewController.tweetUrl = url;
	self.newTweetViewController.tweetText = [[NSString alloc] initWithFormat:@"%@ %@", event.hashtag, session.hashtag];
	
	urlString = [[NSString alloc]  initWithFormat:EVENT_SESSION_RETWEET_URL, event.eventId, session.number];
	url = [[NSURL alloc] initWithString:urlString];
	[urlString release];
	self.retweetUrl = url;
	[url release];
	
	if (![currentSession.number isEqualToString:session.number])
	{
		self.arrayTweets = nil;
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


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc
{
	[event release];
	[session release];
	[currentSession release];
	
	[super dealloc];
}

@end
