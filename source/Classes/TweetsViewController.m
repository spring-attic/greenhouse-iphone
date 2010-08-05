    //
//  TweetsViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/26/10.
//  Copyright 2010 VMware. All rights reserved.
//

// Modeled after Apple's LazyTableImages
// http://developer.apple.com/iphone/library/samplecode/LazyTableImages/Introduction/Intro.html

#import "TweetsViewController.h"
#import "Tweet.h"
#import "OAuthManager.h"
#import "NewTweetViewController.h"


@interface TweetsViewController()

@property (nonatomic, retain) NSMutableArray *arrayTweets;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;

- (void)showTwitterForm;
- (void)startImageDownload:(Tweet *)tweet forIndexPath:(NSIndexPath *)indexPath;

@end


@implementation TweetsViewController

@synthesize arrayTweets;
@synthesize imageDownloadsInProgress;
@synthesize tweetUrl;
@synthesize hashtag;
@synthesize tableViewTweets;
@synthesize newTweetViewController;

- (void)fetchRequest:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	if (ticket.didSucceed)
	{
		self.imageDownloadsInProgress = nil;
		self.imageDownloadsInProgress = [NSMutableDictionary dictionary];		
		self.arrayTweets = nil;
		self.arrayTweets = [[NSMutableArray alloc] init];
		
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

- (void)startImageDownload:(Tweet *)tweet forIndexPath:(NSIndexPath *)indexPath
{
    TweetProfileImageDownloader *profileImageDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (profileImageDownloader == nil) 
    {
        profileImageDownloader = [[TweetProfileImageDownloader alloc] init];
        profileImageDownloader.tweet = tweet;
        profileImageDownloader.indexPathInTableView = indexPath;
        profileImageDownloader.delegate = self;
        [imageDownloadsInProgress setObject:profileImageDownloader forKey:indexPath];
        [profileImageDownloader startDownload];
        [profileImageDownloader release];   
    }
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    if ([self.arrayTweets count] > 0)
    {
        NSArray *visiblePaths = [self.tableViewTweets indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            Tweet *tweet = [self.arrayTweets objectAtIndex:indexPath.row];
            
            if (!tweet.profileImage) // avoid the app icon download if the app already has an icon
            {
                [self startImageDownload:tweet forIndexPath:indexPath];
            }
        }
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)profileImageDidLoad:(NSIndexPath *)indexPath
{
    TweetProfileImageDownloader *profileImageDownloader = [imageDownloadsInProgress objectForKey:indexPath];
	
    if (profileImageDownloader != nil)
    {
        UITableViewCell *cell = [self.tableViewTweets cellForRowAtIndexPath:profileImageDownloader.indexPathInTableView];
        
        // Display the newly loaded image
        cell.imageView.image = profileImageDownloader.tweet.profileImage;
    }
}


#pragma mark -
#pragma mark UIScrollViewDelegate methods

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
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
//	static NSString *PlaceholderCellIdentifier = @"PlaceholderCell";
    
    // add a placeholder cell while waiting on table data
    int tweetCount = [self.arrayTweets count];
	
//	if (tweetCount == 0 && indexPath.row == 0)
//	{
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PlaceholderCellIdentifier];
//        if (cell == nil)
//		{
//            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
//										   reuseIdentifier:PlaceholderCellIdentifier] autorelease];   
//            cell.detailTextLabel.textAlignment = UITextAlignmentCenter;
//			cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//		
//		cell.detailTextLabel.text = @"Loading Tweets…";
//		
//		return cell;
//    }
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
	
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdent] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
		
	// Leave cells empty if there's no data yet
    if (tweetCount > 0)
	{
        Tweet *tweet = (Tweet *)[arrayTweets objectAtIndex:indexPath.row];
		
		[cell.textLabel setText:tweet.text];
		[cell.detailTextLabel setText:tweet.fromUser];
		
        // Only load cached images; defer new downloads until scrolling ends
        if (!tweet.profileImage)
        {
            if (tableView.dragging == NO && tableView.decelerating == NO)
            {
                [self startImageDownload:tweet forIndexPath:indexPath];
            }
            // if a download is deferred or in progress, return a placeholder image
            cell.imageView.image = [UIImage imageNamed:@"spring.png"];
        }
        else
        {
			[cell.imageView setImage:tweet.profileImage];
        }
		
    }	
	
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
	
	UIBarButtonItem *buttonItemCompose = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose 
																				target:self 
																				action:@selector(showTwitterForm)];
	self.navigationItem.rightBarButtonItem = buttonItemCompose;
	[buttonItemCompose release];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
	
    // terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
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
