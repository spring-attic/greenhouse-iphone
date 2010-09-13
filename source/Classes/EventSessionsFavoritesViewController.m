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

@end


@implementation EventSessionsFavoritesViewController

@synthesize eventSessionController;

#pragma mark -
#pragma mark EventSessionControllerDelegate methods

- (void)fetchFavoriteSessionsDidFinishWithResults:(NSArray *)sessions
{
	eventSessionController.delegate = nil;
	self.eventSessionController = nil;
	
	[self performSelector:@selector(dataSourceDidFinishLoadingNewData) withObject:nil afterDelay:0.0f];
	
	self.arraySessions = sessions;
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark PullRefreshTableViewController methods

- (void)reloadTableViewDataSource
{
	self.eventSessionController = [EventSessionController eventSessionController];
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
