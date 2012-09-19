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
//  GHEventSessionsCurrentViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/13/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "GHEventSessionsCurrentViewController.h"
#import "Event.h"
#import "EventSession.h"
#import "GHEventController.h"
#import "GHEventSessionController.h"

@interface GHEventSessionsCurrentViewController ()

@property (nonatomic, strong) GHEventSessionController *eventSessionController;
@property (nonatomic, strong) NSArray *currentSessions;
@property (nonatomic, strong) NSArray *upcomingSessions;

@end

@implementation GHEventSessionsCurrentViewController

@synthesize eventSessionController;
@synthesize currentSessions = _currentSessions;
@synthesize upcomingSessions = _upcomingSessions;

- (EventSession *)eventSessionForIndexPath:(NSIndexPath *)indexPath
{
	EventSession *session = nil;
	
	if (indexPath.section == 0)
	{
		session = [_currentSessions objectAtIndex:indexPath.row];
	}
	else if (indexPath.section == 1)
	{
		session = [_upcomingSessions objectAtIndex:indexPath.row];
	}
	
	return session;
}

- (BOOL)displayLoadingCell
{
	NSInteger currentCount = [_currentSessions count];
	NSInteger upcomingCount = [_upcomingSessions count];
	
	return (currentCount == 0 && upcomingCount == 0);
}


#pragma mark -
#pragma mark EventSessionControllerDelegate methods

- (void)fetchCurrentSessionsDidFinishWithResults:(NSArray *)sessions
{
    NSMutableArray *currentSessions = [[NSMutableArray alloc] init];
	NSMutableArray *upcomingSessions = [[NSMutableArray alloc] init];
    
    NSDate *nextStartTime = nil;
    NSDate *now = [NSDate date];
    DLog(@"%@", now.description);
    
    for (EventSession *session in sessions)
    {
        DLog(@"%@ - %@", [session.startTime description], [session.endTime description]);
        
        if ([now compare:session.startTime] == NSOrderedDescending &&
            [now compare:session.endTime] == NSOrderedAscending)
        {
            // find the sessions that are happening now
            [currentSessions addObject:session];
        }
        else if ([now compare:session.startTime] == NSOrderedAscending)
        {
            // determine the start time of the next block of sessions
            if (nextStartTime == nil)
            {
                nextStartTime = session.startTime;
            }
            
            if ([nextStartTime compare:session.startTime] == NSOrderedSame)
            {
                // only show the sessions occurring in the next block
                [upcomingSessions addObject:session];
            }
        }
    }
    
	self.currentSessions = currentSessions;
	self.upcomingSessions = upcomingSessions;
	[self.tableView reloadData];
	[self dataSourceDidFinishLoadingNewData];
}

- (void)fetchCurrentSessionsDidFailWithError:(NSError *)error
{
	[self dataSourceDidFinishLoadingNewData];
}


#pragma mark -
#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (_currentSessions && _upcomingSessions)
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
	if (_currentSessions && section == 0)
	{
		return [_currentSessions count];
	}
	else if (_upcomingSessions && section == 1)
	{
		return [_upcomingSessions count];
	}
	else 
	{
		return 1;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	
	if ([_currentSessions count] > 0 && section == 0)
	{
		return @"Happening Now:";
	}
	else if ([_upcomingSessions count] > 0 && section == 1)
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

//- (BOOL)shouldReloadData
//{
//	return (arrayCurrentSessions == nil || self.lastRefreshExpired);
//}

- (void)reloadTableViewDataSource
{
	[eventSessionController sendRequestForCurrentSessionsWithEventId:self.event.eventId delegate:self];
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
	self.lastRefreshKey = @"EventSessionsCurrentViewController_LastRefresh";
	
    [super viewDidLoad];
	
	self.title = @"Current";
	self.eventSessionController = [[GHEventSessionController alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.currentSessions = nil;
    self.upcomingSessions = nil;
    
    [super viewWillAppear:animated];
    
    [eventSessionController fetchCurrentSessionsWithEventId:self.event.eventId delegate:self];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.eventSessionController = nil;
	self.currentSessions = nil;
	self.upcomingSessions = nil;
}

@end
