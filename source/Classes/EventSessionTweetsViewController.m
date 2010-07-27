    //
//  EventSessionTweetsViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/26/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "EventSessionTweetsViewController.h"


@implementation EventSessionTweetsViewController

@synthesize session;

- (void)refreshData
{
	// must make this assignment for parent class to work correctly
	self.hashtag = session.hashtag;
	
	NSString *urlString = [NSString stringWithFormat:SESSION_TWEETS_URL, session.sessionId];
	[self fetchJSONDataWithURL:[NSURL URLWithString:urlString]];
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[self refreshData];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.session = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[session release];
	
    [super dealloc];
}


@end
