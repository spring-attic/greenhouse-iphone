    //
//  EventsMainViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/8/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "EventsMainViewController.h"
#import "OAuthManager.h"
#import "Event.h"


@interface EventsMainViewController()

@property (nonatomic, retain) NSArray *arrayEvents;
@property (nonatomic, retain) EventController *eventController;

- (void)completeFetchEvents:(NSArray *)events;

@end


@implementation EventsMainViewController

@synthesize arrayEvents;
@synthesize eventController;
@synthesize barButtonRefresh;
@synthesize eventDetailsViewController;

- (void)completeFetchEvents:(NSArray *)events
{
	self.eventController = nil;
	self.arrayEvents = events;
	[self.tableView reloadData];
	[self dataSourceDidFinishLoadingNewData];
}


#pragma mark -
#pragma mark EventControllerDelegate methods

- (void)fetchEventsDidFinishWithResults:(NSArray *)events
{
	[self completeFetchEvents:events];
}

- (void)fetchEventsDidFailWithError:(NSError *)error
{
	NSArray *array = [[NSArray alloc] init];
	[self completeFetchEvents:array];
	[array release];
}


#pragma mark -
#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	Event *event = (Event *)[arrayEvents objectAtIndex:indexPath.row];
	eventDetailsViewController.event = event;
	[self.navigationController pushViewController:eventDetailsViewController animated:YES];
}


#pragma mark -
#pragma mark UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdent = @"cell";
	static NSString *PlaceholderCellIdentifier = @"PlaceholderCell";
    
    // add a placeholder cell while waiting on table data
    int count = [self.arrayEvents count];
	
	if (count == 0 && indexPath.row == 0)
	{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PlaceholderCellIdentifier];
		
        if (cell == nil)
		{
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:PlaceholderCellIdentifier] autorelease];
            cell.detailTextLabel.textAlignment = UITextAlignmentCenter;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
		
		cell.detailTextLabel.text = @"Loading Events…";
		
		return cell;
    }	
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
	
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdent] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
	
	Event *event = (Event *)[arrayEvents objectAtIndex:indexPath.row];
	
	[cell.textLabel setText:event.title];
	[cell.detailTextLabel setText:event.groupName];
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (arrayEvents)
	{
		return [arrayEvents count];
	}
	else 
	{
		return 1;
	}
}


#pragma mark -
#pragma mark PullRefreshTableViewController methods

- (void)reloadData
{
	if ([self shouldReloadData])
	{
		[self reloadTableViewDataSource];
	}
}

- (void)reloadTableViewDataSource
{
	self.eventController = [[EventController alloc] init];
	eventController.delegate = self;
	
	[eventController fetchEvents];	
}

- (BOOL)shouldReloadData
{
	return (!arrayEvents || self.lastRefreshExpired);
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
	self.lastRefreshKey = @"EventsMainViewController_LastRefresh";
	
	[super viewDidLoad];
	
	self.title = @"Upcoming Events";
	
	self.eventDetailsViewController = [[EventDetailsViewController alloc] initWithNibName:nil bundle:nil];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{	
	[super viewDidUnload];
	
	self.arrayEvents = nil;
	self.eventController = nil;
	self.barButtonRefresh = nil;
	self.eventDetailsViewController = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[arrayEvents release];
	[eventController release];
	[barButtonRefresh release];
	[eventDetailsViewController release];
	
    [super dealloc];
}


@end
