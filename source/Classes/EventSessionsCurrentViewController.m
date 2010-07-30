    //
//  EventCurrentSessionsViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/13/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "EventSessionsCurrentViewController.h"
#import "EventSessionDetailsViewController.h"
#import "EventSession.h"


@interface EventSessionsCurrentViewController()

@property (nonatomic, retain) NSMutableArray *arrayCurrentSessions;
@property (nonatomic, retain) NSMutableArray *arrayUpcomingSessions;

- (EventSession *)eventSessionForIndexPath:(NSIndexPath *)indexPath;

@end


@implementation EventSessionsCurrentViewController

@synthesize arrayCurrentSessions;
@synthesize arrayUpcomingSessions;
@synthesize event;
@synthesize eventSessionDetailsViewController;
@synthesize tableViewSessions;


- (void)fetchRequest:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	if (ticket.didSucceed)
	{
		[arrayCurrentSessions removeAllObjects];
		[arrayUpcomingSessions removeAllObjects];
				
		NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSArray *array = [responseBody JSONValue];
		[responseBody release];
		
		DLog(@"%@", array);
		
		NSDate *nextStartTime = nil;
		
		for (NSDictionary *d in array) 
		{
			EventSession *session = [[EventSession alloc] initWithDictionary:d];
			
			NSDate *now = [NSDate date];
			
			if ([now compare:session.startTime] == NSOrderedDescending &&
				[now compare:session.endTime] == NSOrderedAscending)
			{
				// find the sessions that are happening now
				[arrayCurrentSessions addObject:session];
			}
			else if ([now compare:session.startTime] == NSOrderedAscending)
			{
				// determine the start time of the next block of sessions
				if (nextStartTime == nil)
				{
					nextStartTime = session.startTime;
				}
				
				if ([nextStartTime compare:session.startTime] == NSOrderedSame)
				{
					// only show the sessions occurring in the next block
					[arrayUpcomingSessions addObject:session];
				}
			}
			
			[session release];
		}
				
		[tableViewSessions reloadData];
	}
}

- (EventSession *)eventSessionForIndexPath:(NSIndexPath *)indexPath
{
	EventSession *session = nil;
	
	if (indexPath.section == 0)
	{
		session = (EventSession *)[arrayCurrentSessions objectAtIndex:indexPath.row];
	}
	else if (indexPath.section == 1)
	{
		session = (EventSession *)[arrayUpcomingSessions objectAtIndex:indexPath.row];	
	}
	
	return session;
}


#pragma mark -
#pragma mark DataViewDelegate

- (void)refreshView
{
	
}

- (void)fetchData
{
	NSString *urlString = [[NSString alloc] initWithFormat:EVENT_CURRENT_SESSIONS_URL, event.eventId];
	[self fetchJSONDataWithURL:[NSURL URLWithString:urlString]];
	[urlString release];	
}


#pragma mark -
#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	eventSessionDetailsViewController.event = event;
	eventSessionDetailsViewController.session = [self eventSessionForIndexPath:indexPath];
	[self.navigationController pushViewController:eventSessionDetailsViewController animated:YES];
}


#pragma mark -
#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdent = @"cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
	
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdent] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	EventSession *session = [self eventSessionForIndexPath:indexPath];
		
	if (session)
	{
		[cell.textLabel setText:session.title];
		[cell.detailTextLabel setText:session.leaderDisplay];
	}
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch (section) 
	{
		case 0:
			return [arrayCurrentSessions count];
			break;
		case 1:
			return [arrayUpcomingSessions count];
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
			return @"Happening Now:";
			break;
		case 1:
			return @"Up Next:";
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
	
	self.title = @"Current";
	
	self.eventSessionDetailsViewController = [[EventSessionDetailsViewController alloc] initWithNibName:nil bundle:nil];
	
	self.arrayCurrentSessions = [[NSMutableArray alloc] init];
	self.arrayUpcomingSessions = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.arrayCurrentSessions = nil;
	self.arrayUpcomingSessions = nil;
	self.event = nil;
	self.eventSessionDetailsViewController = nil;
	self.tableViewSessions = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[arrayCurrentSessions release];
	[arrayUpcomingSessions release];
	[event release];
	[eventSessionDetailsViewController release];
	[tableViewSessions release];
	
    [super dealloc];
}


@end
