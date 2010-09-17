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
#import "EventSessionRateViewController.h"


@interface EventSessionDetailsViewController()

@property (nonatomic, retain) EventSessionController *eventSessionController;

- (void)updateRatingImages:(double)rating;
- (void)setRating:(double)rating imageView:(UIImageView *)imageView;
- (void)updateFavoriteSession;

@end


@implementation EventSessionDetailsViewController

@synthesize eventSessionController;
@synthesize event;
@synthesize session;
@synthesize arrayMenuItems;
@synthesize labelTitle;
@synthesize labelLeader;
@synthesize labelTime;
@synthesize imageViewRating1;
@synthesize imageViewRating2;
@synthesize imageViewRating3;
@synthesize imageViewRating4;
@synthesize imageViewRating5;
@synthesize tableViewMenu;
@synthesize sessionDescriptionViewController;
@synthesize sessionTweetsViewController;
@synthesize sessionRateViewController;

- (void)updateRatingImages:(double)rating
{	
	[self setRating:rating imageView:imageViewRating1];
	[self setRating:rating imageView:imageViewRating2];
	[self setRating:rating imageView:imageViewRating3];
	[self setRating:rating imageView:imageViewRating4];
	[self setRating:rating imageView:imageViewRating5];	
}

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
	self.eventSessionController = [EventSessionController eventSessionController];
	eventSessionController.delegate = self;
	
	[eventSessionController updateFavoriteSession:session.number withEventId:event.eventId];
}


#pragma mark -
#pragma mark EventSessionControllerDelegate methods

- (void)updateFavoriteSessionDidFinish
{
	eventSessionController.delegate = nil;
	self.eventSessionController = nil;
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
			session.isFavorite = !session.isFavorite;
			[tableView reloadData];
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
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
	
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	if (indexPath.row == 2)
	{
		cell.accessoryType = session.isFavorite ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
	}
	else if (indexPath.row == 3)
	{
		cell.accessoryType = UITableViewCellAccessoryNone;
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
#pragma mark DataViewController methods

- (void)refreshView
{
	if (session)
	{
		labelTitle.text = session.title;
		labelLeader.text = session.leaderDisplay;
		
		sessionDescriptionViewController.session = session;
		sessionTweetsViewController.event = event;
		sessionTweetsViewController.session = session;
		sessionRateViewController.event = event;
		sessionRateViewController.session = session;
				
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"h:mm a"];
		NSString *formattedStartTime = [dateFormatter stringFromDate:session.startTime];
		NSString *formattedEndTime = [dateFormatter stringFromDate:session.endTime];
		[dateFormatter release];
		
		NSString *formattedTime = [[NSString alloc] initWithFormat:@"%@ - %@", formattedStartTime, formattedEndTime];
		labelTime.text = formattedTime;
		[formattedTime release];
		
		NSArray *items = nil;
		
		if ([session.endTime compare:[NSDate date]] == NSOrderedDescending)
		{
			items = [[NSArray alloc] initWithObjects:@"Description", @"Tweets", @"Favorite", nil];
		}
		else 
		{
			items = [[NSArray alloc] initWithObjects:@"Description", @"Tweets", @"Favorite", @"rate", nil];
		}
			 
		 self.arrayMenuItems = items;
		 [items release];

		
		[tableViewMenu reloadData];
		
		[self updateRatingImages:session.rating];
	}	
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.title = @"Session";
	
	self.sessionDescriptionViewController = [[EventSessionDescriptionViewController alloc] initWithNibName:nil bundle:nil];
	self.sessionTweetsViewController = [[EventSessionTweetsViewController alloc] initWithNibName:nil bundle:nil];
	self.sessionRateViewController = [[EventSessionRateViewController alloc] initWithNibName:nil bundle:nil];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.eventSessionController = nil;
	self.event = nil;
	self.session = nil;
	self.arrayMenuItems = nil;
	self.labelTitle = nil;
	self.labelLeader = nil;
	self.labelTime = nil;
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


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[eventSessionController release];
	[event release];
	[session release];
	[arrayMenuItems release];
	[labelTitle release];
	[labelLeader release];
	[labelTime release];
	[imageViewRating1 release];
	[imageViewRating2 release];
	[imageViewRating3 release];
	[imageViewRating4 release];
	[imageViewRating5 release];
	[tableViewMenu release];
	[sessionDescriptionViewController release];
	[sessionTweetsViewController release];
	[sessionRateViewController release];
	
    [super dealloc];
}


@end
