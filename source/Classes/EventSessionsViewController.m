    //
//  EventSessionsViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/2/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "EventSessionsViewController.h"


@implementation EventSessionsViewController

@synthesize arraySessions;
@synthesize event;
@synthesize sessionDetailsViewController;
@synthesize tableViewSessions;

- (void)fetchRequest:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	if (ticket.didSucceed)
	{
		self.arraySessions = [[NSMutableArray alloc] init];
		
		NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSArray *array = [responseBody yajl_JSON];
		[responseBody release];
		
		DLog(@"%@", array);
		
		for (NSDictionary *d in array) 
		{
			EventSession *session = [[EventSession alloc] initWithDictionary:d];
			[self.arraySessions addObject:session];			
			[session release];
		}
		
		[self.tableViewSessions reloadData];
	}
}

- (EventSession *)eventSessionForIndexPath:(NSIndexPath *)indexPath
{
	EventSession *session = nil;
	
	@try 
	{
		session = (EventSession *)[self.arraySessions objectAtIndex:indexPath.row];
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

- (BOOL)displayLoadingCell
{
	NSInteger count = [self.arraySessions count];
	return (count == 0);
}


#pragma mark -
#pragma mark DataViewDelegate

- (void)refreshView
{
	self.arraySessions = nil;
	[self.tableViewSessions reloadData];
}

- (void)fetchData
{
	
}


#pragma mark -
#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	self.sessionDetailsViewController.event = self.event;
	self.sessionDetailsViewController.session = [self eventSessionForIndexPath:indexPath];
	[self.navigationController pushViewController:self.sessionDetailsViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat height = 44.0f;
	
	@try 
	{
		EventSession *session = [self eventSessionForIndexPath:indexPath];
		
		if (session)
		{
			CGSize maxSize = CGSizeMake(tableViewSessions.frame.size.width - 40.0f, CGFLOAT_MAX);
			CGSize textSize = [session.title sizeWithFont:[UIFont boldSystemFontOfSize:16.0f] constrainedToSize:maxSize lineBreakMode:UILineBreakModeWordWrap];
			height = MAX(textSize.height + 26.0f, 44.0f);
		}
	}
	@catch (NSException * e) 
	{
		DLog(@"%@", [e reason]);
	}
	@finally 
	{
		return height;
	}
}


#pragma mark -
#pragma mark UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdent = @"cell";
	static NSString *PlaceholderCellIdentifier = @"PlaceholderCell";
    
    // add a placeholder cell while waiting on table data
	if ([self displayLoadingCell] && indexPath.row == 0)
	{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PlaceholderCellIdentifier];
		
        if (cell == nil)
		{
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:PlaceholderCellIdentifier] autorelease];
            cell.detailTextLabel.textAlignment = UITextAlignmentCenter;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
		
		cell.detailTextLabel.text = @"Loading Sessions…";
		
		return cell;
    }	
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
	
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdent] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		[cell.textLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
		[cell.textLabel setNumberOfLines:0];		
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
	NSInteger numberOfRows;
	
	@try 
	{
		if (self.arraySessions)
		{
			numberOfRows = [self.arraySessions count];
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


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.sessionDetailsViewController = [[EventSessionDetailsViewController alloc] initWithNibName:nil bundle:nil];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.arraySessions = nil;
	self.event = nil;
	self.sessionDetailsViewController = nil;
	self.tableViewSessions = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[arraySessions release];
	[event release];
	[sessionDetailsViewController release];
	[tableViewSessions release];
	
    [super dealloc];
}


@end
