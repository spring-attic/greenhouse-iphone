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
//  GHEventSessionsViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/2/10.
//

#import "GHEventSessionsViewController.h"
#import "GHEventSessionDetailsViewController.h"
#import "Event.h"
#import "EventSession.h"
#import "EventSessionLeader.h"
#import "GHEventController.h"
#import "GHEventSessionController.h"

@interface GHEventSessionsViewController ()

@end

@implementation GHEventSessionsViewController

@synthesize visibleIndexPath;
@synthesize sessions;
@synthesize event;
@synthesize sessionDetailsViewController;

- (EventSession *)eventSessionForIndexPath:(NSIndexPath *)indexPath
{
    EventSession *session = nil;
	
	@try 
	{
		session = [self.sessions objectAtIndex:indexPath.row];
	}
	@catch (NSException * e) 
	{
		DLog(@"%@", [e reason]);
	}
	@finally 
	{
		return session;
	}
}

- (BOOL)displayLoadingCell
{
	NSInteger count = [self.sessions count];
	return (count == 0);
}


#pragma mark -
#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.visibleIndexPath = indexPath;
    [[GHEventSessionController sharedInstance] setSelectedSession:[self eventSessionForIndexPath:indexPath]];
	[self.navigationController pushViewController:self.sessionDetailsViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat height = 44.0f;
	EventSession *session = [self eventSessionForIndexPath:indexPath];
	if (session)
	{
        // adjust the height of the cell based on the length of the session title
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
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:PlaceholderCellIdentifier];
            cell.detailTextLabel.textAlignment = UITextAlignmentCenter;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
		
		cell.detailTextLabel.text = @"Loading Sessions…";
		
		return cell;
    }	
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
	
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdent];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
		
		[cell.textLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
		[cell.textLabel setNumberOfLines:0];		
	}
	
	EventSession *session = [self eventSessionForIndexPath:indexPath];
	
	if (session)
	{
		[cell.textLabel setText:session.title];
        NSMutableArray *leaders = [[NSMutableArray alloc] initWithCapacity:session.leaders.count];
        [session.leaders enumerateObjectsUsingBlock:^(EventSessionLeader *leader, BOOL *stop) {
            [leaders addObject:[NSString stringWithFormat:@"%@ %@", leader.firstName, leader.lastName]];
        }];
		[cell.detailTextLabel setText:[leaders componentsJoinedByString:@", "]];
	}
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (self.sessions)
	{
		return [self.sessions count];
	}
	else 
	{
		return 1;
	}
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
    DLog(@"");
	
	self.sessionDetailsViewController = [[GHEventSessionDetailsViewController alloc] initWithNibName:nil bundle:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.event = [[GHEventController sharedInstance] fetchSelectedEvent];
    if (self.event == nil)
    {
        DLog(@"selected event not available")
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    
    [super viewWillAppear:animated];
    DLog(@"");

    // clear table of data
	self.sessions = nil;
	[self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    DLog(@"");
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    DLog(@"");
	
    self.visibleIndexPath = nil;
	self.sessions = nil;
	self.event = nil;
	self.sessionDetailsViewController = nil;
}

@end
