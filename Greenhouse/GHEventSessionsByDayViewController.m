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
//  GHEventSessionsByDayViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/30/10.
//

#import "GHEventSessionsByDayViewController.h"


@interface GHEventSessionsByDayViewController()

@property (nonatomic, strong) GHEventSessionController *eventSessionController;
@property (nonatomic, strong) NSArray *arrayTimes;
@property (nonatomic, strong) NSDate *currentEventDate;

- (void)completeFetchSessions:(NSArray *)sessions andTimes:(NSArray *)times;

@end


@implementation GHEventSessionsByDayViewController

@synthesize eventSessionController;
@synthesize arrayTimes;
@synthesize currentEventDate;
@synthesize eventDate;

- (GHEventSession *)eventSessionForIndexPath:(NSIndexPath *)indexPath
{
	GHEventSession *session = nil;
	
	@try 
	{
		NSArray *array = (NSArray *)[self.arraySessions objectAtIndex:indexPath.section];
		session = (GHEventSession *)[array objectAtIndex:indexPath.row];
	}
	@catch (NSException * e) 
	{
		DLog(@"%@", [e reason]);
		session = nil;
	}
	@finally 
	{
		return session;
	}
}

- (void)completeFetchSessions:(NSArray *)sessions andTimes:(NSArray *)times
{
	self.eventSessionController = nil;
	self.arraySessions = sessions;
	self.arrayTimes = times;
	[self.tableView reloadData];
	[self dataSourceDidFinishLoadingNewData];
}


#pragma mark -
#pragma mark EventSessionControllerDelegate methods

- (void)fetchSessionsByDateDidFinishWithResults:(NSArray *)sessions andTimes:(NSArray *)times
{
	[self completeFetchSessions:sessions andTimes:times];
}

- (void)fetchSessionsByDateDidFailWithError:(NSError *)error
{
	NSArray *array = [[NSArray alloc] init];
	[self completeFetchSessions:array andTimes:array];
}


#pragma mark -
#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (arrayTimes)
	{
		return [arrayTimes count];
	}
	else 
	{
		return 1;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (self.arraySessions)
	{
		NSArray *array = (NSArray *)[self.arraySessions objectAtIndex:section];
		return [array count];
	}
	else 
	{
		return 1;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString *s = nil;
	
	if (arrayTimes)
	{
		NSDate *sessionTime = (NSDate *)[arrayTimes objectAtIndex:section];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"h:mm a"];
		NSString *dateString = [dateFormatter stringFromDate:sessionTime];
		s = dateString;
	}
	
	return s;
}


#pragma mark -
#pragma mark PullRefreshTableViewController methods

- (void)refreshView
{
	// set the title of the view to the schedule day
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"EEEE"];
	NSString *dateString = [dateFormatter stringFromDate:eventDate];
	self.title = dateString;
	
	if (![self.currentEvent.eventId isEqualToString:self.event.eventId] ||
		[currentEventDate compare:eventDate] != NSOrderedSame)
	{
		self.arraySessions = nil;
		self.arrayTimes = nil;
		[self.tableView reloadData];
	}
	
	self.currentEvent = self.event;
	self.currentEventDate = eventDate;
}

- (BOOL)shouldReloadData
{
	return (self.arraySessions == nil || arrayTimes == nil || self.lastRefreshExpired);
}

- (void)reloadTableViewDataSource
{
	self.eventSessionController = [[GHEventSessionController alloc] init];
	eventSessionController.delegate = self;
	
	[eventSessionController fetchSessionsByEventId:self.event.eventId withDate:eventDate];
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
	self.lastRefreshKey = @"EventSessionsByDayViewController_LastRefresh";
	
    [super viewDidLoad];
	
	self.title = @"Schedule";
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.eventSessionController = nil;
	self.arrayTimes = nil;
	self.currentEventDate = nil;
	self.eventDate = nil;
}

@end
