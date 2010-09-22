    //
//  EventSessionsConferenceFavoritesViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/2/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "EventSessionsConferenceFavoritesViewController.h"


@interface EventSessionsConferenceFavoritesViewController()

@property (nonatomic, retain) EventSessionController *eventSessionController;

- (void)completeFetchConferenceFavoriteSessions:(NSArray *)sessions;

@end


@implementation EventSessionsConferenceFavoritesViewController

@synthesize eventSessionController;

- (void)completeFetchConferenceFavoriteSessions:(NSArray *)sessions
{
	[eventSessionController release];
	self.eventSessionController = nil;
	self.arraySessions = sessions;
	[self.tableView reloadData];
	[self dataSourceDidFinishLoadingNewData];
}

#pragma mark -
#pragma mark EventSessionControllerDelegate methods

- (void)fetchConferenceFavoriteSessionsDidFinishWithResults:(NSArray *)sessions
{
	[self completeFetchConferenceFavoriteSessions:sessions];
}

- (void)fetchConferenceFavoriteSessionsDidFailWithError:(NSError *)error
{
	NSArray *array = [[NSArray alloc] init];
	[self completeFetchConferenceFavoriteSessions:array];
	[array release];
}


#pragma mark -
#pragma mark DataViewController methods

- (void)reloadTableViewDataSource
{
	self.eventSessionController = [[EventSessionController alloc] init];
	eventSessionController.delegate = self;
	
	[eventSessionController fetchConferenceFavoriteSessionsByEventId:self.event.eventId];
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
	self.lastRefreshKey = @"EventSessionFavoritesViewController_LastRefresh";
	
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
	
	self.eventSessionController = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
    [super dealloc];
}


@end
