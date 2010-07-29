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

@property (nonatomic, retain) NSMutableArray *arrayEvents;

@end


@implementation EventsMainViewController

@synthesize arrayEvents;
@synthesize barButtonRefresh;
@synthesize tableViewEvents;
@synthesize eventDetailsViewController;


- (void)fetchRequest:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	if (ticket.didSucceed)
	{
		[arrayEvents removeAllObjects];
		
		NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSArray *array = [responseBody JSONValue];
		[responseBody release];
		
		DLog(@"%@", array);
		
		for (NSDictionary *d in array) 
		{
			Event *event = [[Event alloc] initWithDictionary:d];
			[arrayEvents addObject:event];
			[event release];
		}
		
		[tableViewEvents reloadData];
	}
}


#pragma mark -
#pragma mark DataViewDelegate methods

- (void)refreshView
{
	
}

- (void)fetchData
{
	[self fetchJSONDataWithURL:[NSURL URLWithString:EVENTS_URL]];
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
	static NSString *cellIdent = @"updateCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
	
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdent] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	Event *event = (Event *)[arrayEvents objectAtIndex:indexPath.row];
	
	[cell.textLabel setText:event.title];
	[cell.detailTextLabel setText:event.description];
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (arrayEvents)
	{
		return [arrayEvents count];
	}
	
	return 0;
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.title = @"Events";
	
	self.eventDetailsViewController = [[EventDetailsViewController alloc] initWithNibName:nil bundle:nil];
	self.arrayEvents = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{	
	[super viewDidUnload];
	
	self.arrayEvents = nil;
	self.barButtonRefresh = nil;
	self.tableViewEvents = nil;
	self.eventDetailsViewController = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[arrayEvents release];
	[barButtonRefresh release];
	[tableViewEvents release];
	[eventDetailsViewController release];
	
    [super dealloc];
}


@end
