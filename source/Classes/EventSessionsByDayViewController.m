    //
//  EventSessionsByDayViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/30/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "EventSessionsByDayViewController.h"
#import "EventSession.h"
#import "EventSessionDetailsViewController.h"


@interface EventSessionsByDayViewController()

@property (nonatomic, retain) NSMutableArray *arraySessions;
@property (nonatomic, retain) NSMutableArray *arrayTimes;

- (EventSession *)eventSessionForIndexPath:(NSIndexPath *)indexPath;

@end


@implementation EventSessionsByDayViewController

@synthesize arraySessions;
@synthesize arrayTimes;
@synthesize event;
@synthesize eventDate;
@synthesize tableViewSessions;
@synthesize sessionDetailsViewController;


- (void)fetchRequest:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	if (ticket.didSucceed)
	{
		NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSArray *array = [responseBody JSONValue];
		[responseBody release];
		
		DLog(@"%@", array);
		
		NSMutableArray *arrayBlock = nil;
		NSDate *sessionTime = [NSDate distantPast];
		
		for (NSDictionary *d in array) 
		{
			EventSession *session = [[EventSession alloc] initWithDictionary:d];
			
			// for each time block create an array to hold the sessions for that block
			if ([sessionTime compare:session.startTime] == NSOrderedAscending)
			{
				arrayBlock = [[NSMutableArray alloc] init];
				[arraySessions addObject:arrayBlock];
				[arrayBlock release];
				
				[arrayBlock addObject:session];
			}
			else if ([sessionTime compare:session.startTime] == NSOrderedSame)
			{
				[arrayBlock addObject:session];
			}
			
			sessionTime = session.startTime;
			
			NSDate *date = [session.startTime copyWithZone:NULL];
			[arrayTimes addObject:date];
			[date release];
			
			[session release];
		}
		
		[tableViewSessions reloadData];
	}
}

- (EventSession *)eventSessionForIndexPath:(NSIndexPath *)indexPath
{
	EventSession *session = nil;
	
	@try 
	{
		NSArray *array = (NSArray *)[arraySessions objectAtIndex:indexPath.section];
		session = (EventSession *)[array objectAtIndex:indexPath.row];
	}
	@catch (NSException * e) 
	{
		DLog(@"%@", [e reason]);
		session = nil;
	}
	@finally 
	{
		return session;
	}
}


#pragma mark -
#pragma mark DataViewDelegate

- (void)refreshView
{
	// clear out any existing data
	[arraySessions removeAllObjects];
	[arrayTimes removeAllObjects];
	
	// set the title of the view to the schedule day
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"EEEE"];
	NSString *dateString = [dateFormatter stringFromDate:eventDate];
	[dateFormatter release];
	self.title = dateString;
}

- (void)fetchData
{
	// request the sessions for the selected day
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"YYYY-MM-d"];
	NSString *dateString = [dateFormatter stringFromDate:eventDate];
	[dateFormatter release];
	NSString *urlString = [[NSString alloc] initWithFormat:EVENT_SESSIONS_BY_DAY_URL, event.eventId, dateString];
	[self fetchJSONDataWithURL:[NSURL URLWithString:urlString]];
	[urlString release];	
}


#pragma mark -
#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	sessionDetailsViewController.event = event;
	sessionDetailsViewController.session = [self eventSessionForIndexPath:indexPath];
	[self.navigationController pushViewController:sessionDetailsViewController animated:YES];
}


#pragma mark -
#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [arrayTimes count];
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
	NSInteger rowCount = 0;
	
	@try 
	{
		NSArray *array = (NSArray *)[arraySessions objectAtIndex:section];
		rowCount = [array count];
	}
	@catch (NSException * e) 
	{
		DLog(@"%@", [e reason]);
		rowCount = 0;
	}
	@finally 
	{
		return rowCount;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString *s = nil;
	
	@try 
	{
		NSDate *sessionTime = (NSDate *)[arrayTimes objectAtIndex:section];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"h:mm a"];
		NSString *dateString = [dateFormatter stringFromDate:sessionTime];
		[dateFormatter release];
		s = dateString;		
	}
	@catch (NSException * e) 
	{
		DLog(@"%@", [e reason]);
		s = nil;
	}
	@finally 
	{
		return s;
	}
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.title = @"Schedule";
	
	self.sessionDetailsViewController = [[EventSessionDetailsViewController alloc] initWithNibName:nil bundle:nil];
	
	self.arraySessions = [[NSMutableArray alloc] init];
	self.arrayTimes = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.arraySessions = nil;
	self.arrayTimes = nil;
	self.event = nil;
	self.eventDate = nil;
	self.tableViewSessions = nil;
	self.sessionDetailsViewController = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[arraySessions release];
	[arrayTimes release];
	[event release];
	[eventDate release];
	[tableViewSessions release];
	[sessionDetailsViewController release];
	
    [super dealloc];
}


@end
