    //
//  EventDetailsViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/13/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "EventDetailsViewController.h"
#import "EventDescriptionViewController.h"
#import "EventSessionsMenuViewController.h"
#import "EventTweetsViewController.h"
#import "EventMapViewController.h"


@interface EventDetailsViewController()

@property (nonatomic, retain) NSArray *arrayMenuItems;

@end


@implementation EventDetailsViewController

@synthesize arrayMenuItems;
@synthesize event;
@synthesize labelTitle;
@synthesize labelDescription;
@synthesize labelTime;
@synthesize labelLocation;
@synthesize tableViewMenu;
@synthesize eventDescriptionViewController;
@synthesize eventSessionsMenuViewController;
@synthesize eventTweetsViewController;
@synthesize eventMapViewController;


#pragma mark -
#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.row) 
	{
		case 0:
			[self.navigationController pushViewController:eventDescriptionViewController animated:YES];
			break;
		case 1:
			[self.navigationController pushViewController:eventSessionsMenuViewController animated:YES];
			break;
		case 2:
			[self.navigationController pushViewController:eventTweetsViewController animated:YES];
			break;
		case 3:
			[self.navigationController pushViewController:eventMapViewController animated:YES];
			break;
		default:
			break;
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark -
#pragma mark UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdent = @"menuCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
	
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
	
	NSString *s = (NSString *)[arrayMenuItems objectAtIndex:indexPath.row];
	
	[cell.textLabel setText:s];
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (arrayMenuItems)
	{
		return [arrayMenuItems count];
	}
	
	return 0;
}


#pragma mark -
#pragma mark DataViewController methods

- (void)refreshView
{
	eventDescriptionViewController.event = event;
	eventSessionsMenuViewController.event = event;
	eventTweetsViewController.event = event;
	eventMapViewController.event = event;
		
	labelTitle.text = event.title;
	
	NSDate *date = [event.startTime dateByAddingTimeInterval:86400];
	
	// if start and end time are exactly the same, just display the date
	if ([event.startTime compare:event.endTime] == NSOrderedSame || 
		[event.startTime compare:event.endTime] == NSOrderedDescending)
	{
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"EEEE, MMMM d, YYYY"];
		labelTime.text = [dateFormatter stringFromDate:event.startTime];
		[dateFormatter release];
	}
	
	// If start and end time are same day, show the times for the event
	else if ([event.startTime compare:event.endTime] == NSOrderedAscending &&
			 [date compare:event.endTime] == NSOrderedDescending)
	{
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"EEE, MMM d, YYYY, h:mm a"];		
		NSString *formattedStartTime = [dateFormatter stringFromDate:event.startTime];
		[dateFormatter setDateFormat:@"h:mm a"];
		NSString *formattedEndTime = [dateFormatter stringFromDate:event.endTime];
		[dateFormatter release];
		
		NSString *formattedTime = [[NSString alloc] initWithFormat:@"%@ - %@", formattedStartTime, formattedEndTime];
		labelTime.text = formattedTime;
		[formattedTime release];
	}
	
	// if the times are days apart, display the date range for the event
	else if ([event.startTime compare:event.endTime] == NSOrderedAscending)
	{
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"EEE, MMM d"];		
		NSString *formattedStartTime = [dateFormatter stringFromDate:event.startTime];
		[dateFormatter setDateFormat:@"EEE, MMM d, YYYY"];
		NSString *formattedEndTime = [dateFormatter stringFromDate:event.endTime];
		[dateFormatter release];
		
		NSString *formattedTime = [[NSString alloc] initWithFormat:@"%@ - %@", formattedStartTime, formattedEndTime];
		labelTime.text = formattedTime;
		[formattedTime release];
	}
	
	labelLocation.text = event.location;
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.title = @"Event";
	
	self.arrayMenuItems = [[NSArray alloc] initWithObjects:@"Description", @"Sessions", @"Tweets", @"Map", nil];
	
	self.eventDescriptionViewController = [[EventDescriptionViewController alloc] initWithNibName:nil bundle:nil];
	self.eventSessionsMenuViewController = [[EventSessionsMenuViewController alloc] initWithNibName:nil bundle:nil];
	self.eventTweetsViewController = [[EventTweetsViewController alloc] initWithNibName:nil bundle:nil];
	self.eventMapViewController = [[EventMapViewController alloc] initWithNibName:nil bundle:nil];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.arrayMenuItems = nil;
	self.event = nil;
	self.labelTitle = nil;
	self.labelDescription = nil;
	self.labelTime = nil;
	self.labelLocation = nil;
	self.tableViewMenu = nil;
	self.eventDescriptionViewController = nil;
	self.eventSessionsMenuViewController = nil;
	self.eventTweetsViewController = nil;
	self.eventMapViewController = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[arrayMenuItems release];
	[event release];
	[labelTitle release];
	[labelDescription release];
	[labelTime release];
	[labelLocation release];
	[tableViewMenu release];
	[eventDescriptionViewController release];
	[eventSessionsMenuViewController release];
	[eventTweetsViewController release];
	[eventMapViewController release];
	
    [super dealloc];
}


@end
