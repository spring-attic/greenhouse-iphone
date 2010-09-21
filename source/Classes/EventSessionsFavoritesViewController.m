    //
//  EventSessionsFavoritesViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/2/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "EventSessionsFavoritesViewController.h"


@interface EventSessionsFavoritesViewController()

@property (nonatomic, retain) EventSessionController *eventSessionController;

- (void)completeFetchFavoriteSessions:(NSArray *)sessions;

@end


@implementation EventSessionsFavoritesViewController

@synthesize eventSessionController;

- (void)completeFetchFavoriteSessions:(NSArray *)sessions
{
	self.eventSessionController = nil;
	self.arraySessions = sessions;
	[self.tableView reloadData];
	[self dataSourceDidFinishLoadingNewData];
}

#pragma mark -
#pragma mark EventSessionControllerDelegate methods

- (void)fetchFavoriteSessionsDidFinishWithResults:(NSArray *)sessions
{
	[self completeFetchFavoriteSessions:sessions];
}

- (void)fetchFavoriteSessionsDidFailWithError:(NSError *)error
{
	NSArray *array = [[NSArray alloc] init];
	[self completeFetchFavoriteSessions:array];
	[array release];
}

#pragma mark -
#pragma mark PullRefreshTableViewController methods

- (BOOL)shouldReloadData
{
	return (!self.arraySessions || self.lastRefreshExpired || [EventSessionController shouldRefreshFavorites]);
}

- (void)reloadTableViewDataSource
{
	self.eventSessionController = [[EventSessionController alloc] init];
	eventSessionController.delegate = self;
	
	[eventSessionController fetchFavoriteSessionsByEventId:self.event.eventId];
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
	self.lastRefreshKey = @"EventSessionFavoritesViewController_LastRefresh";
	
    [super viewDidLoad];
	
	self.title = @"My Favorites";
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
	[eventSessionController release];
	
    [super dealloc];
}


@end
