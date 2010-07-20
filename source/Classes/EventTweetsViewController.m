    //
//  EventTweetsViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/13/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "EventTweetsViewController.h"
#import "Tweet.h"
#import "OAuthManager.h"


@interface EventTweetsViewController()

@property (nonatomic, retain) NSMutableArray *arrayTweets;

@end


@implementation EventTweetsViewController

@synthesize arrayTweets;
@synthesize eventId;
@synthesize tableViewTweets;

- (void)refreshData
{
	NSString *urlString = [NSString stringWithFormat:EVENT_TWEETS_URL, eventId];
	[self fetchJSONDataWithURL:[NSURL URLWithString:urlString]];
}

- (void)fetchRequest:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	if (ticket.didSucceed)
	{
		[arrayTweets removeAllObjects];
		
		NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSDictionary *dictionary = [responseBody JSONValue];
		[responseBody release];
		
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
