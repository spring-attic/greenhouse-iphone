    //
//  EventTweetsViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/13/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "EventTweetsViewController.h"


@implementation EventTweetsViewController

@synthesize event;


#pragma mark -
#pragma mark DataViewDelegate methods

- (void)refreshView
{
}

- (void)fetchData;
{
	// must make these assignment for parent class to work correctly
	self.hashtag = event.hashtag;

	NSString *urlString = [[NSString alloc] initWithFormat:EVENT_TWEETS_URL, event.eventId];
	self.tweetUrl = [[NSURL alloc] initWithString:urlString];
	[urlString release];
	
	[self fetchJSONDataWithURL:self.tweetUrl];
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidUnload 
{
    [super viewDidUnload];

	self.event = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[event release];
	
    [super dealloc];
}


@end
