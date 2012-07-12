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
//  EventSessionsViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/2/10.
//

#import "EventSessionsViewController.h"


@implementation EventSessionsViewController

@synthesize arraySessions;
@synthesize event;
@synthesize currentEvent;
@synthesize sessionDetailsViewController;

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
	
	EventSession *session = [self eventSessionForIndexPath:indexPath];
		
	if (session)
	{
		CGSize maxSize = CGSizeMake(tableView.frame.size.width - 40.0f, CGFLOAT_MAX);
		CGSize textSize = [session.title sizeWithFont:[UIFont boldSystemFontOfSize:16.0f] constrainedToSize:maxSize lineBreakMode:UILineBreakModeWordWrap];
		height = MAX(textSize.height + 26.0f, 44.0f);
	}
	
	return height;
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
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
		
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
	if (self.arraySessions)
	{
		return [self.arraySessions count];
	}
	else 
	{
		return 1;
	}
}


#pragma mark -
#pragma mark PullRefreshTableViewController methods

- (void)refreshView
{
	if (![self.currentEvent.eventId isEqualToString:self.event.eventId])
	{
		self.arraySessions = nil;
		
		[self.tableView reloadData];
	}
	
	self.currentEvent = event;
}

- (void)reloadData
{
	if (self.shouldReloadData)
	{
		[self reloadTableViewDataSource];
	}
}

- (BOOL)shouldReloadData
{
	return (!arraySessions || self.lastRefreshExpired);
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
	self.currentEvent = nil;
	self.sessionDetailsViewController = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[arraySessions release];
	[event release];
	[currentEvent release];
	[sessionDetailsViewController release];
	
    [super dealloc];
}


@end
