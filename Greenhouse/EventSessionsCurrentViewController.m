//
//  Copyright 2010-2012 the original author or authors.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//
//  EventCurrentSessionsViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/13/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "EventSessionsCurrentViewController.h"


@interface EventSessionsCurrentViewController()

@property (nonatomic, strong) EventSessionController *eventSessionController;
@property (nonatomic, strong) NSArray *arrayCurrentSessions;
@property (nonatomic, strong) NSArray *arrayUpcomingSessions;

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

@end
