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


#pragma mark -
#pragma mark EventSessionControllerDelegate methods

- (void)fetchCurrentSessionsDidFinishWithResults:(NSArray *)currentSessions upcomingSessions:(NSArray *)upcomingSessions;
{
	eventSessionController.delegate = nil;
	self.eventSessionController = nil;
	
	self.arrayCurrentSessions = currentSessions;
	self.arrayUpcomingSessions = upcomingSessions;
	
	[self.tableViewSessions reloadData];
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
	if (arrayCurrentSessions && arrayUpcomingSessions)
	{
		switch (section) 
		{
			case 0:
				return [arrayCurrentSessions count];
				break;
			case 1:
				return [arrayUpcomingSessions count];
				break;
			default:
				return 0;
				break;
		}
	}
	else
	{
		return 1;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (arrayCurrentSessions && arrayUpcomingSessions)
	{
		switch (section) 
		{
			case 0:
				return @"Happening Now:";
				break;
			case 1:
				return @"Up Next:";
				break;
			default:
				return @"";
				break;
		}
	}
	else
	{
		return @"";
	}
}


#pragma mark -
#pragma mark DataViewController methods

- (void)refreshView
{
	self.arrayCurrentSessions = nil;
	self.arrayUpcomingSessions = nil;
	
	[self.tableViewSessions reloadData];
}

- (void)reloadData
{
	self.eventSessionController = [EventSessionController eventSessionController];
	eventSessionController.delegate = nil;
	
	[eventSessionController fetchCurrentSessionsByEventId:self.event.eventId];
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
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
	[eventSessionController release];
	[arrayCurrentSessions release];
	[arrayUpcomingSessions release];
	
    [super dealloc];
}


@end
