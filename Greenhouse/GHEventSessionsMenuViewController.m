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
//  GHEventSessionsMenuViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/29/10.
//

#import "GHEventSessionsMenuViewController.h"
#import "GHEventSessionsCurrentViewController.h"
#import "GHEventSessionsFavoritesViewController.h"
#import "GHEventSessionsConferenceFavoritesViewController.h"
#import "GHEventSessionsByDayViewController.h"
#import "Event.h"
#import "GHEventController.h"
#import "GHEventSessionController.h"
#import "GHDateHelper.h"

@interface GHEventSessionsMenuViewController ()

@property (nonatomic, strong) Event *currentEvent;
@property (nonatomic, strong) NSArray *arrayMenuItems;
@property (nonatomic, strong) NSArray *arrayEventDates;
@property (nonatomic, strong) NSMutableDictionary *dictionaryViewControllers;

@end

@implementation GHEventSessionsMenuViewController

@synthesize arrayMenuItems;
@synthesize arrayEventDates;
@synthesize dictionaryViewControllers;
@synthesize currentEvent;
@synthesize tableViewMenu;
@synthesize sessionsCurrentViewController;
@synthesize sessionsFavoritesViewController;
@synthesize conferenceFavoritesViewController;
@synthesize sessionsByDayViewController;


#pragma mark -
#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0)
	{
		switch (indexPath.row) 
		{
			case 0:
				[self.navigationController pushViewController:sessionsCurrentViewController animated:YES];
				break;
			case 1:
				[self.navigationController pushViewController:sessionsFavoritesViewController animated:YES];
				break;
			case 2:
				[self.navigationController pushViewController:conferenceFavoritesViewController animated:YES];
				break;
			default:
				break;
		}
	}
	else if (indexPath.section == 1)
	{
		NSDate *date = [arrayEventDates objectAtIndex:indexPath.row];
		GHEventSessionsByDayViewController *vc = (GHEventSessionsByDayViewController *)[dictionaryViewControllers objectForKey:[date description]];
		if (vc == nil)
		{
			vc = [[GHEventSessionsByDayViewController alloc] initWithNibName:@"GHEventSessionsViewController" bundle:nil];
			[dictionaryViewControllers setObject:vc forKey:[date description]];
		}
        [[GHEventSessionController sharedInstance] setSelectedScheduleDate:date];
		[self.navigationController pushViewController:vc animated:YES];
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
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent];
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
			[dateFormatter setDateFormat:@"EEEE, MMMM d"];
			s = [dateFormatter stringFromDate:eventDate];
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
	self.dictionaryViewControllers = [[NSMutableDictionary alloc] init];
	self.sessionsCurrentViewController = [[GHEventSessionsCurrentViewController alloc] initWithNibName:@"GHEventSessionsViewController" bundle:nil];
	self.sessionsFavoritesViewController = [[GHEventSessionsFavoritesViewController alloc] initWithNibName:@"GHEventSessionsViewController" bundle:nil];
	self.conferenceFavoritesViewController = [[GHEventSessionsConferenceFavoritesViewController alloc] initWithNibName:@"GHEventSessionsViewController" bundle:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DLog(@"");
    
    Event *event = [[GHEventController sharedInstance] fetchSelectedEvent];
    if (![currentEvent.eventId isEqualToNumber:event.eventId])
	{
		[dictionaryViewControllers removeAllObjects];
		self.arrayEventDates = [GHDateHelper daysBetweenStartTime:event.startTime endTime:event.endTime];
		[tableViewMenu reloadData];
	}
	
	self.currentEvent = event;
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.arrayMenuItems = nil;
	self.arrayEventDates = nil;
	self.dictionaryViewControllers = nil;
	self.currentEvent = nil;
	self.tableViewMenu = nil;
	self.sessionsCurrentViewController = nil;
	self.sessionsFavoritesViewController = nil;
	self.conferenceFavoritesViewController = nil;
}

@end
