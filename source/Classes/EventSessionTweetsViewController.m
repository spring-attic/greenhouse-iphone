    //
//  EventSessionTweetsViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/26/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "EventSessionTweetsViewController.h"


@implementation EventSessionTweetsViewController

@synthesize event;
@synthesize session;


#pragma mark -
#pragma mark DataViewDelegate

- (void)refreshView
{
}

- (void)fetchData
{
	// must make this assignment for parent class to work correctly
	self.hashtag = [NSString stringWithFormat:@"%@ %@", event.hashtag, session.hashtag];
	
	NSString *urlString = [[NSString alloc] initWithFormat:EVENT_SESSION_TWEETS_URL, event.eventId, session.number];
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
	self.session = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[event release];
	[session release];
	
    [super dealloc];
}


@end
