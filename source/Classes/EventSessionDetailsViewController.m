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
#import "OAuthManager.h"


@interface EventSessionDetailsViewController()

- (void)markSessionAsFavorite;
- (void)putRequest:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
- (void)putRequest:(OAServiceTicket *)ticket didFailWithError:(NSError *)error;

- (void)updateRatingImages:(double)rating;
- (void)setRating:(double)rating imageView:(UIImageView *)imageView;

@end


@implementation EventSessionDetailsViewController

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


- (void)markSessionAsFavorite
{	
	NSString *urlString = [[NSString alloc] initWithFormat:EVENT_SESSIONS_FAVORITE_URL, event.eventId, session.number];
	NSURL *url = [[NSURL alloc] initWithString:urlString];
	[urlString release];
	
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url 
																   consumer:[OAuthManager sharedInstance].consumer
																	  token:[OAuthManager sharedInstance].accessToken
																	  realm:OAUTH_REALM
														  signatureProvider:nil]; // use the default method, HMAC-SHA1
	
	[url release];
	
	[request setHTTPMethod:@"PUT"];
	
	DLog(@"%@", request);
	
	OADataFetcher *fetcher = [[OADataFetcher alloc] init];
	
	[fetcher fetchDataWithRequest:request
						 delegate:self
				didFinishSelector:@selector(putRequest:didFinishWithData:)
				  didFailSelector:@selector(putRequest:didFailWithError:)];
	
	[request release];
}

- (void)putRequest:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	DLog(@"%@", responseBody);
	[responseBody release];
}

- (void)putRequest:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	DLog(@"%@", [error localizedDescription]);
	
	if ([error code] == NSURLErrorUserCancelledAuthentication)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
														message:@"You are not authorized to view the content from greenhouse.com. Please sign out and reauthorize the app." 
													   delegate:self 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:@"Sign Out", nil];
		[alert show];
		[alert release];		
	}
	else 
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
														message:@"An error occurred while connecting to the server." 
													   delegate:nil 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];		
	}
}

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


#pragma mark -
#pragma mark DataViewDelegate

- (void)refreshView
{
	if (session)
	{
		labelTitle.text = session.title;
		labelLeader.text = session.leaderDisplay;
		
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"h:mm a"];
		NSString *formattedStartTime = [dateFormatter stringFromDate:session.startTime];
		NSString *formattedEndTime = [dateFormatter stringFromDate:session.endTime];
		[dateFormatter release];
		
		NSString *formattedTime = [[NSString alloc] initWithFormat:@"%@ - %@", formattedStartTime, formattedEndTime];
		labelTime.text = formattedTime;
		[formattedTime release];
		
		if ([session.endTime compare:[NSDate date]] == NSOrderedDescending)
		{
			self.arrayMenuItems = [[NSArray alloc] initWithObjects:@"Description", @"Tweets", @"Favorite", nil];
		}
		else 
		{
			self.arrayMenuItems = [[NSArray alloc] initWithObjects:@"Description", @"Tweets", @"Favorite", @"Rate", nil];
		}

		[tableViewMenu reloadData];
		
		[self updateRatingImages:session.rating];
	}	
}

- (void)fetchData
{
}


#pragma mark -
#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.row) 
	{
		case 0:
			sessionDescriptionViewController.session = session;
			[self.navigationController pushViewController:sessionDescriptionViewController animated:YES];
			break;
		case 1:
			sessionTweetsViewController.event = event;
			sessionTweetsViewController.session = session;
			[self.navigationController pushViewController:sessionTweetsViewController animated:YES];
			break;
		case 2:
			session.isFavorite = !session.isFavorite;
			[tableView reloadData];
			[self markSessionAsFavorite];
			break;
		case 3:
			sessionRateViewController.event = event;
			sessionRateViewController.session = session;
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
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.title = @"Session";
	
	self.sessionDescriptionViewController = [[EventSessionDescriptionViewController alloc] initWithNibName:nil bundle:nil];
	self.sessionTweetsViewController = [[EventSessionTweetsViewController alloc] initWithNibName:@"TweetsViewController" bundle:nil];
	self.sessionRateViewController = [[EventSessionRateViewController alloc] initWithNibName:nil bundle:nil];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
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
