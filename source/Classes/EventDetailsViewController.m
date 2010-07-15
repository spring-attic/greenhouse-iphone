    //
//  EventDetailsViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/13/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "EventDetailsViewController.h"
#import "EventSessionsViewController.h"
#import "EventTwitterViewController.h"


@interface EventDetailsViewController()

@property (nonatomic, retain) NSArray *arrayMenuItems;

@end


@implementation EventDetailsViewController

@synthesize arrayMenuItems;
@synthesize event;
@synthesize labelTitle;
@synthesize labelDescription;
@synthesize labelStartTime;
@synthesize labelEndTime;
@synthesize labelLocation;
@synthesize labelHashtag;
@synthesize tableViewMenu;
@synthesize eventSessionsViewController;
@synthesize eventTwitterViewController;


#pragma mark -
#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.row) 
	{
		case 0:
			[self.navigationController pushViewController:eventSessionsViewController animated:YES];
			break;
		case 1:
			[self.navigationController pushViewController:eventTwitterViewController animated:YES];
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
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.title = @"Event Details";
	
	self.arrayMenuItems = [[NSArray alloc] initWithObjects:@"Sessions", @"Tweets", nil];
	
	self.eventSessionsViewController = [[EventSessionsViewController alloc] initWithNibName:nil bundle:nil];
	self.eventTwitterViewController = [[EventTwitterViewController alloc] initWithNibName:nil bundle:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	eventTwitterViewController.eventId = event.eventId;
	
	labelTitle.text = event.title;
	labelDescription.text = event.description;
	labelStartTime.text = [event.startTime description];
	labelEndTime.text = [event.endTime description];
	labelLocation.text = event.location;
	labelHashtag.text = event.hashtag;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.arrayMenuItems = nil;
	self.event = nil;
	self.labelTitle = nil;
	self.labelDescription = nil;
	self.labelStartTime = nil;
	self.labelEndTime = nil;
	self.labelLocation = nil;
	self.labelHashtag = nil;
	self.tableViewMenu = nil;
	self.eventSessionsViewController = nil;
	self.eventTwitterViewController = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[arrayMenuItems release];
	[event release];
	[labelTitle release];
	[labelDescription release];
	[labelStartTime release];
	[labelEndTime release];
	[labelLocation release];
	[labelHashtag release];
	[tableViewMenu release];
	[eventSessionsViewController release];
	[eventTwitterViewController release];
	
    [super dealloc];
}


@end
