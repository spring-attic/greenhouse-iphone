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
//  GHEventSessionDetailsViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/21/10.
//

#import "Event.h"
#import "EventSession.h"
#import "EventSessionLeader.h"
#import "VenueRoom.h"
#import "GHEventController.h"
#import "GHEventSessionController.h"
#import "GHEventSessionDetailsViewController.h"
#import "GHEventSessionDescriptionViewController.h"
#import "GHEventSessionTweetsViewController.h"
#import "GHEventSessionRateViewController.h"
#import "GHActivityIndicatorTableViewCell.h"

@interface GHEventSessionDetailsViewController ()

@property (nonatomic, strong) Event *event;
@property (nonatomic, strong) EventSession *session;
@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, copy) NSString *html;
@property (nonatomic, strong) GHActivityIndicatorTableViewCell *favoriteTableViewCell;

- (void)setRating:(double)rating imageView:(UIImageView *)imageView;
- (void)updateFavoriteSession;

@end

@implementation GHEventSessionDetailsViewController

@synthesize favoriteTableViewCell;
@synthesize event;
@synthesize session;
@synthesize menuItems;
@synthesize html;
@synthesize webView;
@synthesize imageViewRating1;
@synthesize imageViewRating2;
@synthesize imageViewRating3;
@synthesize imageViewRating4;
@synthesize imageViewRating5;
@synthesize tableViewMenu;
@synthesize sessionDescriptionViewController;
@synthesize sessionTweetsViewController;
@synthesize sessionRateViewController;


#pragma mark -
#pragma mark Public methods

- (void)updateRating:(double)newRating
{	
	[self setRating:newRating imageView:imageViewRating1];
	[self setRating:newRating imageView:imageViewRating2];
	[self setRating:newRating imageView:imageViewRating3];
	[self setRating:newRating imageView:imageViewRating4];
	[self setRating:newRating imageView:imageViewRating5];	
}


#pragma mark -
#pragma mark Private methods

- (void)setRating:(double)rating imageView:(UIImageView *)imageView 
{
	NSInteger number = imageView.tag;
	if (number <= rating)
	{
		imageView.image = [UIImage imageNamed:@"star.png"];
	}
	else if ((number - 1) < rating && number > rating)
	{
		imageView.image = [UIImage imageNamed:@"star-half.png"];
	}
	else 
	{
		imageView.image = [UIImage imageNamed:@"star-empty.png"];
	}
}

- (void)updateFavoriteSession
{
	[favoriteTableViewCell startAnimating];
	[[GHEventSessionController sharedInstance] updateFavoriteSessionWithEventId:event.eventId sessionNumber:session.number delegate:self];
}


#pragma mark -
#pragma mark EventSessionControllerDelegate methods

- (void)updateFavoriteSessionDidFinishWithResults:(BOOL)isFavorite
{
	[favoriteTableViewCell stopAnimating];
	session.isFavorite = [NSNumber numberWithBool:isFavorite];
	[tableViewMenu reloadData];
}

- (void)updateFavoriteSessionDidFailWithError:(NSError *)error
{
	[favoriteTableViewCell stopAnimating];
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
		case 2:
			[self updateFavoriteSession];
			break;
		case 3:
			[self presentModalViewController:sessionRateViewController animated:YES];
			break;
		default:
			break;
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -
#pragma mark UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdent = @"menuCell";
	static NSString *activityCellIdent = @"activityCellIdent";
	
	UITableViewCell *cell = nil;
	
	if (indexPath.row == 2)
	{
		cell = (GHActivityIndicatorTableViewCell *)[tableView dequeueReusableCellWithIdentifier:activityCellIdent];
		
		if (cell == nil)
		{
			self.favoriteTableViewCell = [[GHActivityIndicatorTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:activityCellIdent];
			cell = favoriteTableViewCell;
		}
	}
	else 
	{
		cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
		
		if (cell == nil)
		{
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
		}
	}

	if (indexPath.row == 2)
	{
		cell.accessoryType = [session.isFavorite boolValue] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
	}
	else if (indexPath.row == 3)
	{
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	else 
	{
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}

	
	NSString *s = (NSString *)[menuItems objectAtIndex:indexPath.row];
	
	[cell.textLabel setText:s];
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (menuItems)
	{
		return [menuItems count];
	}
	
	return 0;
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
    DLog(@"");
	
	self.title = @"Session";
	self.sessionDescriptionViewController = [[GHEventSessionDescriptionViewController alloc] initWithNibName:nil bundle:nil];
	self.sessionTweetsViewController = [[GHEventSessionTweetsViewController alloc] initWithNibName:@"GHTweetsViewController" bundle:nil];
	self.sessionRateViewController = [[GHEventSessionRateViewController alloc] initWithNibName:nil bundle:nil];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"GHEventSessionDetailsContent" ofType:@"html"];
	self.html = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DLog(@"");
    
    self.event = [[GHEventController sharedInstance] fetchSelectedEvent];
    self.session = [[GHEventSessionController sharedInstance] fetchSelectedSession];
    if (self.event == nil || self.session == nil)
    {
        DLog(@"selected event or session not available");
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    else
	{        
        NSString *contentHtml = [self.html copy];
        
        contentHtml = [contentHtml stringByReplacingOccurrencesOfString:@"{{TITLE}}" withString:session.title];
        
        NSMutableArray *leaders = [[NSMutableArray alloc] initWithCapacity:session.leaders.count];
        [session.leaders enumerateObjectsUsingBlock:^(EventSessionLeader *leader, BOOL *stop) {
            [leaders addObject:[NSString stringWithFormat:@"%@ %@", leader.firstName, leader.lastName]];
        }];
        NSString *leadersValue = [leaders componentsJoinedByString:@", "];
        leadersValue = leadersValue != nil ? leadersValue : @"";
        contentHtml = [contentHtml stringByReplacingOccurrencesOfString:@"{{LEADERS}}" withString:leadersValue];
        
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"h:mm a"];
		NSString *formattedStartTime = [dateFormatter stringFromDate:session.startTime];
		NSString *formattedEndTime = [dateFormatter stringFromDate:session.endTime];
		NSString *formattedTime = [[NSString alloc] initWithFormat:@"%@ - %@", formattedStartTime, formattedEndTime];
        
        NSString *timeValue = formattedTime != nil ? formattedTime : @"";
        contentHtml = [contentHtml stringByReplacingOccurrencesOfString:@"{{TIME}}" withString:timeValue];

        NSString *roomValue = session.room.label != nil ? session.room.label : @"";
		contentHtml = [contentHtml stringByReplacingOccurrencesOfString:@"{{ROOM}}" withString:roomValue];
        
        [self.webView loadHTMLString:contentHtml baseURL:nil];
        
		self.menuItems = [[NSArray alloc] initWithObjects:@"Description", @"Tweets", @"Favorite", @"Rate", nil];
		[tableViewMenu reloadData];
		
		[self updateRating:[session.rating doubleValue]];
        
        sessionRateViewController.sessionDetailsViewController = self;
	}
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    DLog(@"");
	
	self.favoriteTableViewCell = nil;
	self.event = nil;
	self.session = nil;
	self.menuItems = nil;
    self.html = nil;
    self.webView = nil;
	self.imageViewRating1 = nil;
	self.imageViewRating2 = nil;
	self.imageViewRating3 = nil;
	self.imageViewRating4 = nil;
	self.imageViewRating5 = nil;
	self.tableViewMenu = nil;
	self.sessionDescriptionViewController = nil;
	self.sessionTweetsViewController = nil;
	self.sessionRateViewController = nil;
}

@end
