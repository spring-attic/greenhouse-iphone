    //
//  EventSessionsConferenceFavoritesViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/2/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "EventSessionsConferenceFavoritesViewController.h"


@implementation EventSessionsConferenceFavoritesViewController


#pragma mark -
#pragma mark DataViewDelegate

- (void)fetchData
{
	NSString *urlString = [[NSString alloc] initWithFormat:EVENT_SESSIONS_CONFERENCE_FAVORITES_URL, self.event.eventId];
	[self fetchJSONDataWithURL:[NSURL URLWithString:urlString]];
	[urlString release];	
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.title = @"Conference Favorites";
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
    [super dealloc];
}


@end