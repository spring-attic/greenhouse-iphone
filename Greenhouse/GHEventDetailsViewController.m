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
//  GHEventDetailsViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/13/10.
//

#import "GHEventDetailsViewController.h"
#import "Event.h"
#import "GHEventController.h"
#import "GHEventDescriptionViewController.h"
#import "GHEventSessionsScheduleViewController.h"
#import "GHEventSessionsFavoritesViewController.h"
#import "GHEventTweetsViewController.h"
#import "GHEventMapViewController.h"

@interface GHEventDetailsViewController()

@property (nonatomic, strong) Event *event;
@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) NSArray *viewControllers;

@end

@implementation GHEventDetailsViewController

@synthesize menuItems;
@synthesize viewControllers;
@synthesize event;
@synthesize labelTitle;
@synthesize labelDescription;
@synthesize labelTime;
@synthesize labelLocation;
@synthesize tableViewMenu;
@synthesize eventDescriptionViewController;
@synthesize sessionsScheduleViewController;
@synthesize sessionsFavoritesViewController;
@synthesize eventTweetsViewController;
@synthesize eventMapViewController;


#pragma mark -
#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc = [viewControllers objectAtIndex:indexPath.row];
    if (vc && ![vc isEqual:[NSNull null]])
    {
        [self.navigationController pushViewController:vc animated:YES];
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
	
	NSString *s = (NSString *)[menuItems objectAtIndex:indexPath.row];
	
	[cell.textLabel setText:s];
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (menuItems)
	{
		return [menuItems count];
	}
	
	return 0;
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
    DLog(@"");
	
	self.title = @"Event";
	self.menuItems = [[NSArray alloc] initWithObjects:@"Description", @"Schedule", @"Favorites", @"Tweets", @"Map", nil];
	self.eventDescriptionViewController = [[GHEventDescriptionViewController alloc] initWithNibName:nil bundle:nil];
	self.sessionsScheduleViewController = [[GHEventSessionsScheduleViewController alloc] initWithNibName:nil bundle:nil];
    self.sessionsFavoritesViewController = [[GHEventSessionsFavoritesViewController alloc] initWithNibName:@"GHEventSessionsViewController" bundle:nil];
	self.eventTweetsViewController = [[GHEventTweetsViewController alloc] initWithNibName:@"GHTweetsViewController" bundle:nil];
	self.eventMapViewController = [[GHEventMapViewController alloc] initWithNibName:nil bundle:nil];
    self.viewControllers = [[NSArray alloc] initWithObjects:
                            eventDescriptionViewController,
                            sessionsScheduleViewController,
                            sessionsFavoritesViewController,
                            eventTweetsViewController,
                            eventMapViewController,
                            nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DLog(@"");

    self.event = [[GHEventController sharedInstance] fetchSelectedEvent];
    if (self.event == nil)
    {
        DLog(@"selected event not available");
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    else
    {
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
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    DLog(@"");
	
	self.menuItems = nil;
    self.viewControllers = nil;
	self.event = nil;
	self.labelTitle = nil;
	self.labelDescription = nil;
	self.labelTime = nil;
	self.labelLocation = nil;
	self.tableViewMenu = nil;
	self.eventDescriptionViewController = nil;
	self.sessionsScheduleViewController = nil;
    self.sessionsFavoritesViewController = nil;
	self.eventTweetsViewController = nil;
	self.eventMapViewController = nil;
}

@end
