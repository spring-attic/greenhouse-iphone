    //
//  EventCurrentSessionsViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/13/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "EventSessionsCurrentViewController.h"


@interface EventSessionsCurrentViewController()

@property (nonatomic, retain) EventSessionController *eventSessionController;
@property (nonatomic, retain) NSArray *arrayCurrentSessions;
@property (nonatomic, retain) NSArray *arrayUpcomingSessions;

- (void)completeFetchCurrentSessions:(NSArray *)currentSessions upcomingSessions:(NSArray *)upcomingSessions;

@end


@implementation EventSessionsCurrentViewController

@synthesize eventSessionController;
@synthesize arrayCurrentSessions;
@synthesize arrayUpcomingSessions;

- (EventSession *)eventSessionForIndexPath:(NSIndexPath *)indexPath
{
	EventSession *session = nil;
	
	if (indexPath.section == 0)
	{
		session = (EventSession *)[arrayCurrentSessions objectAtIndex:indexPath.row];
	}
	else if (indexPath.section == 1)
	{
		session = (EventSession *)[arrayUpcomingSessions objectAtIndex:indexPath.row];	
	}
	
	return session;
}

- (BOOL)displayLoadingCell
{
	NSInteger currentCount = [arrayCurrentSessions count];
	NSInteger upcomingCount = [arrayUpcomingSessions count];
	
	return (currentCount == 0 && upcomingCount == 0);
}

- (void)completeFetchCurrentSessions:(NSArray *)currentSessions upcomingSessions:(NSArray *)upcomingSessions
{
	[eventSessionController release];
	self.eventSessionController = nil;
	self.arrayCurrentSessions = currentSessions;
	self.arrayUpcomingSessions = upcomingSessions;
	[self.tableView reloadData];
	[self dataSourceDidFinishLoadingNewData];
}


#pragma mark -
#pragma mark EventSessionControllerDelegate methods

- (void)fetchCurrentSessionsDidFinishWithResults:(NSArray *)currentSessions upcomingSessions:(NSArray *)upcomingSessions
{
	[self completeFetchCurrentSessions:currentSessions upcomingSessions:upcomingSessions];
}

- (void)fetchCurrentSessionsDidFailWithError:(NSError *)error
{
	NSArray *array = [[NSArray alloc] init];
	[self completeFetchCurrentSessions:array upcomingSessions:array];
	[array release];
}


#pragma mark -
#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (arrayCurrentSessions && arrayUpcomingSessions)
	{
		return 2;
	}
	else 
	{
		return 1;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (arrayCurrentSessions && section == 0)
	{
		return [arrayCurrentSessions count];
	}
	else if (arrayUpcomingSessions && section == 1)
	{
		return [arrayUpcomingSessions count];
	}
	else 
	{
		return 1;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	
	if ([arrayCurrentSessions count] > 0 && section == 0)
	{
		return @"Happening Now:";
	}
	else if ([arrayUpcomingSessions count] > 0 && section == 1)
	{
		return @"Up Next:";
	}
	else 
	{
		return @"";
	}	
}


#pragma mark -
#pragma mark PullRefreshTableViewController methods

- (void)refreshView
{
	if (![self.currentEvent.eventId isEqualToString:self.event.eventId])
	{
		self.arrayCurrentSessions = nil;
		self.arrayUpcomingSessions = nil;
	
		[self.tableView reloadData];
	}
	
	self.currentEvent = self.event;
}

- (BOOL)shouldReloadData
{
	return (arrayCurrentSessions == nil || self.lastRefreshExpired);
}

- (void)reloadTableViewDataSource
{
	self.eventSessionController = [[EventSessionController alloc] init];
	eventSessionController.delegate = self;
	
	[eventSessionController fetchCurrentSessionsByEventId:self.event.eventId];
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
	self.lastRefreshKey = @"EventSessionsCurrentViewController_LastRefresh";
	
    [super viewDidLoad];
	
	self.title = @"Current";
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.eventSessionController = nil;
	self.arrayCurrentSessions = nil;
	self.arrayUpcomingSessions = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[arrayCurrentSessions release];
	[arrayUpcomingSessions release];
	
    [super dealloc];
}


@end
