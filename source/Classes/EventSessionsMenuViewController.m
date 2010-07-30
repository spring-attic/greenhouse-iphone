    //
//  EventSessionsMenuViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/29/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "EventSessionsMenuViewController.h"
#import "EventSessionsCurrentViewController.h"


@interface EventSessionsMenuViewController()

@property (nonatomic, retain) NSArray *arrayMenuItems;
@property (nonatomic, retain) NSMutableArray *arrayEventDays;

@end


@implementation EventSessionsMenuViewController

@synthesize arrayMenuItems;
@synthesize arrayEventDays;
@synthesize event;
@synthesize tableViewMenu;
@synthesize sessionsCurrentViewController;


#pragma mark -
#pragma mark DataViewDelegate methods

- (void)refreshView
{	
	sessionsCurrentViewController.event = event;
	
	[arrayEventDays removeAllObjects];
	
	NSDate *eventDate = [[event.startTime copyWithZone:NULL] autorelease];
	
	while ([eventDate compare:event.endTime] != NSOrderedDescending)
	{
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"EEEE, MMMM d, YYYY"];
		NSString *s = [dateFormatter stringFromDate:eventDate];
		[dateFormatter release];
		
		[arrayEventDays addObject:s];
		
		NSTimeInterval ti = (60 * 60 * 24);
		eventDate = [eventDate dateByAddingTimeInterval:ti];
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
		[self.navigationController pushViewController:sessionsCurrentViewController animated:YES];
	}
	
//	switch (indexPath.row) 
//	{
//		case 0:
//			[self.navigationController pushViewController:eventDescriptionViewController animated:YES];
//			break;
//		case 1:
//			[self.navigationController pushViewController:eventSessionsViewController animated:YES];
//			break;
//		case 2:
//			[self.navigationController pushViewController:eventTweetsViewController animated:YES];
//			break;
//		case 3:
//			[self.navigationController pushViewController:eventMapViewController animated:YES];
//			break;
//		default:
//			break;
//	}
	
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
			s = (NSString *)[arrayEventDays objectAtIndex:indexPath.row];
			break;
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
			return [arrayEventDays count];
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
	self.arrayEventDays = [[NSMutableArray alloc] init];
	
	self.sessionsCurrentViewController = [[EventSessionsCurrentViewController alloc] initWithNibName:nil bundle:nil];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.arrayMenuItems = nil;
	self.arrayEventDays = nil;
	self.event = nil;
	self.tableViewMenu = nil;
	self.sessionsCurrentViewController = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[arrayMenuItems release];
	[arrayEventDays release];
	[event release];
	[tableViewMenu release];
	[sessionsCurrentViewController release];
	
    [super dealloc];
}


@end
