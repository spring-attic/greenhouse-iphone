    //
//  EventSessionDetailsViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/21/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "EventSessionDetailsViewController.h"
#import "EventSessionDescriptionViewController.h"
#import "EventSessionTweetsViewController.h"


@implementation EventSessionDetailsViewController

@synthesize event;
@synthesize session;
@synthesize arrayMenuItems;
@synthesize labelTitle;
@synthesize labelLeader;
@synthesize labelTime;
@synthesize tableViewMenu;
@synthesize sessionDescriptionViewController;
@synthesize sessionTweetsViewController;


#pragma mark -
#pragma mark DataViewDelegate

- (void)refreshView
{
	if (session)
	{
		sessionDescriptionViewController.session = session;
		sessionTweetsViewController.event = event;
		sessionTweetsViewController.session = session;
		
		labelTitle.text = session.title;
		labelLeader.text = session.leaderDisplay;
		
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"h:mma"];
		NSString *formattedStartTime = [dateFormatter stringFromDate:session.startTime];
		NSString *formattedEndTime = [dateFormatter stringFromDate:session.endTime];
		[dateFormatter release];
		
		NSString *formattedTime = [[NSString alloc] initWithFormat:@"%@ - %@", formattedStartTime, formattedEndTime];
		labelTime.text = formattedTime;
		[formattedTime release];
	}	
}

- (void)fetchData
{
}


#pragma mark -
#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.row) 
	{
		case 0:
			[self.navigationController pushViewController:sessionDescriptionViewController animated:YES];
			break;
		case 1:
			[self.navigationController pushViewController:sessionTweetsViewController animated:YES];
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
	
	self.title = @"Session";
	
	self.sessionDescriptionViewController = [[EventSessionDescriptionViewController alloc] initWithNibName:nil bundle:nil];
	self.sessionTweetsViewController = [[EventSessionTweetsViewController alloc] initWithNibName:@"TweetsViewController" bundle:nil];
	
	self.arrayMenuItems = [[NSArray alloc] initWithObjects:@"Description", @"Tweets", nil];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.event = nil;
	self.session = nil;
	self.arrayMenuItems = nil;
	self.labelTitle = nil;
	self.labelLeader = nil;
	self.labelTime = nil;
	self.tableViewMenu = nil;
	self.sessionDescriptionViewController = nil;
	self.sessionTweetsViewController = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[event release];
	[session release];
	[arrayMenuItems release];
	[labelTitle release];
	[labelLeader release];
	[labelTime release];
	[tableViewMenu release];
	[sessionDescriptionViewController release];
	[sessionTweetsViewController release];
	
    [super dealloc];
}


@end
