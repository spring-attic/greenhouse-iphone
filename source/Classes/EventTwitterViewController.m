    //
//  EventTwitterViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/13/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "EventTwitterViewController.h"
#import "Tweet.h"
#import "OAuthManager.h"


@interface EventTwitterViewController()

@property (nonatomic, retain) NSMutableArray *arrayTweets;

@end


@implementation EventTwitterViewController

@synthesize arrayTweets;
@synthesize eventId;
@synthesize tableViewTweets;

- (void)refreshData
{
	[[OAuthManager sharedInstance] fetchTweetsWithEventId:eventId
												 delegate:self 
										didFinishSelector:@selector(showTweets:) 
										  didFailSelector:@selector(showErrorMessage:)];
}

- (void)showTweets:(NSString *)details
{
	[arrayTweets removeAllObjects];
	
	NSDictionary *dictionary = [details JSONValue];
	DLog(@"%@", dictionary);
	
	NSArray *array = (NSArray *)[dictionary objectForKey:@"tweets"];
	
	for (NSDictionary *d in array) 
	{
		Tweet *tweet = [[Tweet alloc] initWithDictionary:d];
		[arrayTweets addObject:tweet];
		[tweet release];
	}
	
	[tableViewTweets reloadData];
}

- (void)showErrorMessage:(NSError *)error
{
	NSString *message = nil;
	
	if ([error code] == NSURLErrorUserCancelledAuthentication)
	{
		message = @"You are not authorized to view the content from greenhouse.com. Please sign out and reauthorize the app.";
	}
	else 
	{
		message = @"An error occurred while connecting to the server.";
	}
	
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
													message:message 
												   delegate:nil 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}


#pragma mark -
#pragma mark UITableViewDelegate methods

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//	
//}


#pragma mark -
#pragma mark UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdent = @"tweetCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
	
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdent] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	Tweet *tweet = (Tweet *)[arrayTweets objectAtIndex:indexPath.row];
	
	[cell.textLabel setText:tweet.text];
	[cell.detailTextLabel setText:tweet.fromUser];
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (arrayTweets)
	{
		return [arrayTweets count];
	}
	
	return 0;
}


#pragma mark -
#pragma mark UIViewController methods

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.title = @"Recent Tweets";
	
	self.arrayTweets = [[NSMutableArray alloc] init];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[self refreshData];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
    [super viewDidUnload];

	self.arrayTweets = nil;
    self.tableViewTweets = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[arrayTweets release];
	[tableViewTweets release];
	
    [super dealloc];
}


@end
