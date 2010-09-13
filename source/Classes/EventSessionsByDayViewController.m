    //
//  EventSessionsByDayViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/30/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "EventSessionsByDayViewController.h"


@interface EventSessionsByDayViewController()

@property (nonatomic, retain) EventSessionController *eventSessionController;
@property (nonatomic, retain) NSArray *arrayTimes;

@end


@implementation EventSessionsByDayViewController

@synthesize eventSessionController;
@synthesize arrayTimes;
@synthesize eventDate;

- (EventSession *)eventSessionForIndexPath:(NSIndexPath *)indexPath
{
	EventSession *session = nil;
	
	@try 
	{
		NSArray *array = (NSArray *)[self.arraySessions objectAtIndex:indexPath.section];
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
#pragma mark EventSessionControllerDelegate methods

- (void)fetchSessionsByDateDidFinishWithResults:(NSArray *)sessions andTimes:(NSArray *)times
{
	eventSessionController.delegate = nil;
	self.eventSessionController = nil;
	
	self.arraySessions = sessions;
	self.arrayTimes = times;
	
	[self.tableViewSessions reloadData];
}


#pragma mark -
#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	NSInteger numberOfSections;
	
	@try 
	{
		if (arrayTimes)
		{
			numberOfSections = [arrayTimes count];
		}
		else 
		{
			numberOfSections = 1;
		}

	}
	@catch (NSException * e) 
	{
		DLog(@"%@", [e reason]);
		numberOfSections = 0;
	}
	@finally 
	{
		return numberOfSections;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger numberOfRows;
	
	@try 
	{
		if (self.arraySessions)
		{
			NSArray *array = (NSArray *)[self.arraySessions objectAtIndex:section];
			numberOfRows = [array count];
		}
		else 
		{
			numberOfRows = 1;
		}
	}
	@catch (NSException * e) 
	{
		DLog(@"%@", [e reason]);
		numberOfRows = 0;
	}
	@finally 
	{
		return numberOfRows;
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
#pragma mark DataViewController methods

- (void)refreshView
{
	// clear out any existing data
	self.arraySessions = nil;
	self.arrayTimes = nil;
	[self.tableViewSessions reloadData];
	
	// set the title of the view to the schedule day
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"EEEE"];
	NSString *dateString = [dateFormatter stringFromDate:eventDate];
	[dateFormatter release];
	self.title = dateString;
}

- (void)reloadData
{
	self.eventSessionController = [EventSessionController eventSessionController];
	eventSessionController.delegate = self;
	
	[eventSessionController fetchSessionsByEventId:self.event.eventId withDate:eventDate];
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.title = @"Schedule";
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.eventSessionController = nil;
	self.arrayTimes = nil;
	self.eventDate = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[eventSessionController release];
	[arrayTimes release];
	[eventDate release];
	
    [super dealloc];
}


@end
