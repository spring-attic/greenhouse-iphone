//
//  EventTweetsViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 9/12/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "EventTweetsViewController.h"


@interface EventTweetsViewController()

@property (nonatomic, retain) Event *currentEvent;

@end


@implementation EventTweetsViewController

@synthesize event;
@synthesize currentEvent;

#pragma mark -
#pragma mark PullRefreshTableViewController methods

- (void)refreshView
{
	NSString *urlString = [[NSString alloc] initWithFormat:EVENT_TWEETS_URL, event.eventId];
	NSURL *url = [[NSURL alloc] initWithString:urlString];
	[urlString release];
	self.tweetUrl = url;
	[url release];
	
	self.tweetViewController.tweetUrl = url;
	self.tweetViewController.tweetText = event.hashtag;
	
	urlString = [[NSString alloc]  initWithFormat:EVENT_RETWEET_URL, event.eventId];
	url = [[NSURL alloc] initWithString:urlString];
	[urlString release];
	self.retweetUrl = url;
	[url release];
	
	if (![currentEvent.eventId isEqualToString:event.eventId])
	{
		self.isLoading = YES;
		[self.arrayTweets removeAllObjects];
		[self.tableView reloadData];
	}
	
	self.currentEvent = event;
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad
{
	self.lastRefreshKey = @"EventTweetsViewController_LastRefresh";
	
	[super viewDidLoad];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	
	self.event = nil;
	self.currentEvent = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc
{
	[event release];
	[currentEvent release];
	
	[super dealloc];
}

@end
