//
//  Copyright 2010-2012 the original author or authors.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//
//  GHEventsMainViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/8/10.
//

#import "GHEventsMainViewController.h"
#import "Event.h"

@interface GHEventsMainViewController()

@property (nonatomic, strong) NSArray *events;

@end

@implementation GHEventsMainViewController

@synthesize events = _events;
@synthesize barButtonRefresh;
@synthesize eventDetailsViewController;


#pragma mark -
#pragma mark EventControllerDelegate methods

- (void)fetchEventsDidFinishWithResults:(NSArray *)events
{
    self.events = events;
	[self.tableView reloadData];
	[self dataSourceDidFinishLoadingNewData];
}

- (void)fetchEventsDidFailWithError:(NSError *)error
{
	[self dataSourceDidFinishLoadingNewData];
}


#pragma mark -
#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (_events)
	{
		Event *event = [_events objectAtIndex:indexPath.row];
        [[GHEventController sharedInstance] setSelectedEvent:event];
		[self.navigationController pushViewController:eventDetailsViewController animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
	}
}


#pragma mark -
#pragma mark UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdent = @"cell";
	static NSString *PlaceholderCellIdentifier = @"PlaceholderCell";
    
    // add a placeholder cell while waiting on table data
    int count = [self.events count];
	
	if (count == 0 && indexPath.row == 0)
	{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PlaceholderCellIdentifier];
		
        if (cell == nil)
		{
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:PlaceholderCellIdentifier];
            cell.detailTextLabel.textAlignment = UITextAlignmentCenter;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
		
		cell.detailTextLabel.text = @"Loading Events…";
		
		return cell;
    }	
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
	
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdent];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
	
	Event *event = [_events objectAtIndex:indexPath.row];
	
	[cell.textLabel setText:event.title];
	[cell.detailTextLabel setText:event.groupName];
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (_events)
	{
		return [_events count];
	}
	else 
	{
		return 1;
	}
}


#pragma mark -
#pragma mark PullRefreshTableViewController methods

- (BOOL)lastRefreshExpired
{
	// if the last refresh was older than the configured time, then expire the data
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setWeek:-1];
    NSDate *expireDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:[NSDate date] options:0];    
    DLog(@"expireDate: %@", expireDate);
    DLog(@"lastRefresh: %@", self.lastRefreshDate);
	return ([self.lastRefreshDate compare:expireDate] == NSOrderedAscending);
}

- (void)reloadTableViewDataSource
{
    [[GHEventController sharedInstance] sendRequestForEventsWithDelegate:self];
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
	self.lastRefreshKey = @"EventsMainViewController_LastRefresh";
	[super viewDidLoad];
    DLog(@"");
    
	self.title = @"Upcoming Events";
	self.eventDetailsViewController = [[GHEventDetailsViewController alloc] initWithNibName:nil bundle:nil];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Events"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:nil
                                                                            action:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DLog(@"");
    
	self.events = [[GHEventController sharedInstance] fetchEvents];
    if (self.events == nil || self.events.count == 0 || self.lastRefreshExpired)
    {
        [[GHEventController sharedInstance] sendRequestForEventsWithDelegate:self];
    }
}

- (void)viewDidUnload 
{	
	[super viewDidUnload];
    DLog(@"");
    
	self.events = nil;
	self.barButtonRefresh = nil;
	self.eventDetailsViewController = nil;
}

@end
