    //
//  EventCurrentSessionsViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/13/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "EventSessionsCurrentViewController.h"


@interface EventSessionsCurrentViewController()

@property (nonatomic, retain) NSMutableArray *arrayUpcomingSessions;

@end


@implementation EventSessionsCurrentViewController

@synthesize arrayUpcomingSessions;

- (void)fetchRequest:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	if (ticket.didSucceed)
	{
		self.arraySessions = [[NSMutableArray alloc] init];
		self.arrayUpcomingSessions = [[NSMutableArray alloc] init];
				
		NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSArray *array = [responseBody yajl_JSON];
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
				[self.arraySessions addObject:session];
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
				
		[self.tableViewSessions reloadData];
	}
}

- (EventSession *)eventSessionForIndexPath:(NSIndexPath *)indexPath
{
	EventSession *session = nil;
	
	if (indexPath.section == 0)
	{
		session = (EventSession *)[self.arraySessions objectAtIndex:indexPath.row];
	}
	else if (indexPath.section == 1)
	{
		session = (EventSession *)[arrayUpcomingSessions objectAtIndex:indexPath.row];	
	}
	
	return session;
}

- (BOOL)displayLoadingCell
{
	NSInteger currentCount = [self.arraySessions count];
	NSInteger upcomingCount = [self.arrayUpcomingSessions count];
	
	return (currentCount == 0 && upcomingCount == 0);
}


#pragma mark -
#pragma mark DataViewDelegate

- (void)refreshView
{
	self.arraySessions = nil;
	self.arrayUpcomingSessions = nil;
	[self.tableViewSessions reloadData];
}

- (void)fetchData
{
	NSString *urlString = [[NSString alloc] initWithFormat:EVENT_SESSIONS_CURRENT_URL, self.event.eventId];
	[self fetchJSONDataWithURL:[NSURL URLWithString:urlString]];
	[urlString release];	
}


#pragma mark -
#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (self.arraySessions && self.arrayUpcomingSessions)
	{
		return 2;
	}
	else 
	{
		return 1;
	}

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (self.arraySessions && self.arrayUpcomingSessions)
	{
		switch (section) 
		{
			case 0:
				return [self.arraySessions count];
				break;
			case 1:
				return [self.arrayUpcomingSessions count];
				break;
			default:
				return 0;
				break;
		}
	}
	else
	{
		return 1;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (self.arraySessions && self.arrayUpcomingSessions)
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
	else
	{
		return @"";
	}
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.title = @"Current";
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.arrayUpcomingSessions = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[arrayUpcomingSessions release];
	
    [super dealloc];
}


@end
