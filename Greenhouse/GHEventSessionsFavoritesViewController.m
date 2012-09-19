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
//  GHEventSessionsFavoritesViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/2/10.
//

#import "GHEventSessionsFavoritesViewController.h"
#import "Event.h"
#import "EventSession.h"
#import "GHEventSessionController.h"

@interface GHEventSessionsFavoritesViewController ()

@property (nonatomic, strong) NSArray *times;

- (void)reloadTableDataWithSessions:(NSArray *)sessions;

@end

@implementation GHEventSessionsFavoritesViewController

@synthesize times = _times;

- (void)reloadTableDataWithSessions:(NSArray *)sessions
{
    NSMutableArray *timeBlocks = [[NSMutableArray alloc] init];
	NSMutableArray *times = [[NSMutableArray alloc] init];
    NSMutableArray *timeBlock = nil;
    NSDate *sessionTime = [NSDate distantPast];
    
    for (EventSession *session in sessions)
    {
        // for each time block create an array to hold the sessions for that block
        if ([sessionTime compare:session.startTime] == NSOrderedAscending)
        {
            timeBlock = [[NSMutableArray alloc] init];
            [timeBlocks addObject:timeBlock];
            [timeBlock addObject:session];
            
            NSDate *date = [session.startTime copy];
            [times addObject:date];
        }
        else if ([sessionTime compare:session.startTime] == NSOrderedSame)
        {
            [timeBlock addObject:session];
        }
        
        sessionTime = session.startTime;
    }
    
	self.sessions = timeBlocks;
	self.times = times;
    [self.tableView reloadData];

    @try
    {
        [self.tableView scrollToRowAtIndexPath:self.visibleIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        self.visibleIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    @catch (NSException *exception)
    {
        // content changed and row is no longer available
        DLog(@"%@", [exception reason]);
    }
}


#pragma mark -
#pragma mark GHEventSessionsViewController methods

- (EventSession *)eventSessionForIndexPath:(NSIndexPath *)indexPath
{
	EventSession *session = nil;
	
	@try
	{
		NSArray *array = [self.sessions objectAtIndex:indexPath.section];
		session = [array objectAtIndex:indexPath.row];
	}
	@catch (NSException * e)
	{
		DLog(@"%@", [e reason]);
	}
	@finally
	{
		return session;
	}
}


#pragma mark -
#pragma mark EventSessionControllerDelegate methods

- (void)fetchFavoriteSessionsDidFinishWithResults:(NSArray *)sessions
{
    [self reloadTableDataWithSessions:sessions];
	[self dataSourceDidFinishLoadingNewData];
}

- (void)fetchFavoriteSessionsDidFailWithError:(NSError *)error
{
    if (self.sessions == nil && self.times == nil)
    {
        NSArray *empty = [NSArray array];
        self.sessions = empty;
        self.times = empty;
        [self.tableView reloadData];
    }
	[self dataSourceDidFinishLoadingNewData];
}


#pragma mark -
#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (_times)
	{
		return [_times count];
	}
	else
	{
		return 1;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (self.sessions)
	{
		NSArray *array = [self.sessions objectAtIndex:section];
		return [array count];
	}
	else
	{
		return 1;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString *sectionTitle = nil;
	if (_times)
	{
		NSDate *sessionTime = [_times objectAtIndex:section];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"EEEE, MMM d, h:mm a"];
		NSString *dateString = [dateFormatter stringFromDate:sessionTime];
		sectionTitle = dateString;
	}
	
	return sectionTitle;
}


#pragma mark -
#pragma mark PullRefreshTableViewController methods

- (void)reloadTableViewDataSource
{
	[[GHEventSessionController sharedInstance] sendRequestForFavoriteSessionsByEventId:self.event.eventId delegate:self];
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
	self.lastRefreshKey = @"EventSessionFavoritesViewController_LastRefresh";
    [super viewDidLoad];
    DLog(@"");
	
	self.title = @"Favorite Sessions";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DLog(@"");
    
    // fetch the favorite sessions data
   	self.sessions = [[GHEventSessionController sharedInstance] fetchFavoriteSessionsWithEventId:self.event.eventId];
    if (self.sessions && self.sessions.count > 0)
    {
        [self reloadTableDataWithSessions:self.sessions];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    DLog(@"");
    
    if (self.sessions == nil || self.sessions.count == 0 || self.lastRefreshExpired)
    {
        [[GHEventSessionController sharedInstance] sendRequestForFavoriteSessionsByEventId:self.event.eventId delegate:self];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    DLog(@"");
    
    self.times = nil;
}

@end
