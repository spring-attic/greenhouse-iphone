    //
//  TweetsViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/26/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "TweetsViewController.h"
#import "Tweet.h"
#import "OAuthManager.h"
#import "NewTweetViewController.h"


@interface TweetsViewController()

@property (nonatomic, retain) NSMutableArray *arrayTweets;

- (void)showTwitterForm;

@end


@implementation TweetsViewController

@synthesize arrayTweets;
@synthesize tweetUrl;
@synthesize hashtag;
@synthesize tableViewTweets;
@synthesize newTweetViewController;

- (void)refreshData
{
	// override in subclass
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

- (void)showTwitterForm
{
	newTweetViewController.tweetUrl = tweetUrl;
	newTweetViewController.hashtag = hashtag;
	
	[self presentModalViewController:newTweetViewController animated:YES];
}


#pragma mark -
#pragma mark UITableViewDelegate methods

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//	
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//	return 44.0f;
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
	
	NSURL *url =[NSURL URLWithString:tweet.profileImageUrl];
	NSData *data = [NSData dataWithContentsOfURL:url];
	UIImage *image = [UIImage imageWithData:data];
	
	[cell.textLabel setText:tweet.text];
	[cell.detailTextLabel setText:tweet.fromUser];
	[cell.imageView setImage:image];
	
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

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.title = @"Tweets";
	
	self.newTweetViewController = [[NewTweetViewController alloc] initWithNibName:nil bundle:nil];
	
	self.arrayTweets = [[NSMutableArray alloc] init];
	
	UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showTwitterForm)];
	self.navigationItem.rightBarButtonItem = buttonItem;
	[buttonItem release];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[self refreshData];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.arrayTweets = nil;
	self.tweetUrl = nil;
	self.hashtag = nil;
    self.tableViewTweets = nil;
	self.newTweetViewController = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[arrayTweets release];
	[tweetUrl release];
	[hashtag release];
	[tableViewTweets release];
	[newTweetViewController release];
	
    [super dealloc];
}


@end
