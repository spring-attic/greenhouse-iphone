    //
//  EventSessionsMenuViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/29/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "EventSessionsMenuViewController.h"
#import "EventSessionsCurrentViewController.h"
#import "EventSessionsViewController.h"


@interface EventSessionsMenuViewController()

@property (nonatomic, retain) NSArray *arrayMenuItems;
@property (nonatomic, retain) NSMutableArray *arrayEventDates;

@end


@implementation EventSessionsMenuViewController

@synthesize arrayMenuItems;
@synthesize arrayEventDates;
@synthesize event;
@synthesize tableViewMenu;
@synthesize sessionsCurrentViewController;
@synthesize sessionsViewController;


#pragma mark -
#pragma mark DataViewDelegate methods

- (void)refreshView
{	
	sessionsCurrentViewController.event = event;
	sessionsViewController.event = event;
	
	[arrayEventDates removeAllObjects];
	
	NSDate *eventDate = [[event.startTime copyWithZone:NULL] autorelease];
	
	while ([eventDate compare:event.endTime] != NSOrderedDescending)
	{
		[arrayEventDates addObject:eventDate];
		
		eventDate = [eventDate dateByAddingTimeInterval:86400];
	}
	
	[tableViewMenu reloadData];
}

- (void)fetchData
{
	
}


#pragma mark -
#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0 && indexPath.row == 0)
	{
		switch (indexPath.row) 
		{
			case 0:
				[self.navigationController pushViewController:sessionsCurrentViewController animated:YES];
				break;
			case 1:
				// favorites
				break;
			case 2:
				// conference favorites
				break;
			default:
				break;
		}
	}
	else if (indexPath.section == 1)
	{
		NSDate *date = (NSDate *)[arrayEventDates objectAtIndex:indexPath.row];
		sessionsViewController.eventDate = date;
		[self.navigationController pushViewController:sessionsViewController animated:YES];
	}
		
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark -
#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdent = @"menuCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
	
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	NSString *s;
	
	switch (indexPath.section) 
	{
		case 0:
			s = (NSString *)[arrayMenuItems objectAtIndex:indexPath.row];
			break;
		case 1:
		{
			NSDate *eventDate = (NSDate *)[arrayEventDates objectAtIndex:indexPath.row];
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setDateFormat:@"EEEE"];
			s = [dateFormatter stringFromDate:eventDate];
			[dateFormatter release];
			break;
		}
		default:
			s = @"";
			break;
	}	
	
	[cell.textLabel setText:s];
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch (section) 
	{
		case 0:
			return [arrayMenuItems count];
			break;
		case 1:
			return [arrayEventDates count];
			break;
		default:
			return 0;
			break;
	}
	
	return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch (section) 
	{
		case 0:
			return @"Filtered";
			break;
		case 1:
			return @"Schedule by Day";
			break;
		default:
			return @"";
			break;
	}
}

#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.title = @"Sessions";
	
	self.arrayMenuItems = [[NSArray alloc] initWithObjects:@"Current", @"My Favorites", @"Conference Favorites", nil];
	self.arrayEventDates = [[NSMutableArray alloc] init];
	
	self.sessionsCurrentViewController = [[EventSessionsCurrentViewController alloc] initWithNibName:nil bundle:nil];
	self.sessionsViewController = [[EventSessionsViewController alloc] initWithNibName:nil bundle:nil];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.arrayMenuItems = nil;
	self.arrayEventDates = nil;
	self.event = nil;
	self.tableViewMenu = nil;
	self.sessionsCurrentViewController = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[arrayMenuItems release];
	[arrayEventDates release];
	[event release];
	[tableViewMenu release];
	[sessionsCurrentViewController release];
	
    [super dealloc];
}


@end
