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
//  GHEventDetailsViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/13/10.
//

#import "GHEventDetailsViewController.h"
#import "GHEventDescriptionViewController.h"
#import "GHEventSessionsMenuViewController.h"
#import "GHEventTweetsViewController.h"
#import "GHEventMapViewController.h"


@interface GHEventDetailsViewController()

@property (nonatomic, strong) NSArray *arrayMenuItems;

@end


@implementation GHEventDetailsViewController

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
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent];
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
		NSString *formattedTime = [[NSString alloc] initWithFormat:@"%@ - %@", formattedStartTime, formattedEndTime];
		labelTime.text = formattedTime;
	}
	
	// if the times are days apart, display the date range for the event
	else if ([event.startTime compare:event.endTime] == NSOrderedAscending)
	{
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"EEE, MMM d"];		
		NSString *formattedStartTime = [dateFormatter stringFromDate:event.startTime];
		[dateFormatter setDateFormat:@"EEE, MMM d, YYYY"];
		NSString *formattedEndTime = [dateFormatter stringFromDate:event.endTime];		
		NSString *formattedTime = [[NSString alloc] initWithFormat:@"%@ - %@", formattedStartTime, formattedEndTime];
		labelTime.text = formattedTime;
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
	
	self.eventDescriptionViewController = [[GHEventDescriptionViewController alloc] initWithNibName:nil bundle:nil];
	self.eventSessionsMenuViewController = [[GHEventSessionsMenuViewController alloc] initWithNibName:nil bundle:nil];
	self.eventTweetsViewController = [[GHEventTweetsViewController alloc] initWithNibName:@"GHTweetsViewController" bundle:nil];
	self.eventMapViewController = [[GHEventMapViewController alloc] initWithNibName:nil bundle:nil];
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

@end
