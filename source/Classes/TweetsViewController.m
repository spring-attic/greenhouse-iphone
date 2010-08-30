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
#import "TweetTableViewCell.h"
#import "Tweet.h"
#import "OAuthManager.h"
#import "NewTweetViewController.h"
#import "TweetDetailsViewController.h"


@interface TweetsViewController()

@property (nonatomic, retain) NSArray *arrayTweets;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, retain) TwitterController *twitterController;

- (void)showTwitterForm;
- (void)startImageDownload:(Tweet *)tweet forIndexPath:(NSIndexPath *)indexPath;

@end


@implementation TweetsViewController

@synthesize arrayTweets;
@synthesize imageDownloadsInProgress;
@synthesize twitterController;
@synthesize tweetUrl;
@synthesize retweetUrl;
@synthesize hashtag;
@synthesize newTweetViewController;
@synthesize tweetDetailsViewController;

- (void)showTwitterForm
{
	[self presentModalViewController:newTweetViewController animated:YES];
}

- (void)startImageDownload:(Tweet *)tweet forIndexPath:(NSIndexPath *)indexPath
{
    TwitterProfileImageDownloader *profileImageDownloader = [imageDownloadsInProgress objectForKey:indexPath];
	
    if (profileImageDownloader == nil) 
    {
        profileImageDownloader = [[TwitterProfileImageDownloader alloc] init];
        profileImageDownloader.tweet = tweet;
        profileImageDownloader.indexPathInTableView = indexPath;
        profileImageDownloader.delegate = self;
        [imageDownloadsInProgress setObject:profileImageDownloader forKey:indexPath];
        [profileImageDownloader startDownload];
        [profileImageDownloader release];   
    }
}

// this method is used in case the user scrolled into a set of cells that don't have their profile images yet
- (void)loadImagesForOnscreenRows
{
    if ([self.arrayTweets count] > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
		
        for (NSIndexPath *indexPath in visiblePaths)
        {
            Tweet *tweet = [self.arrayTweets objectAtIndex:indexPath.row];
            
            if (!tweet.profileImage) // avoid the profile image download if it already has an image
            {
                [self startImageDownload:tweet forIndexPath:indexPath];
            }
        }
    }
}


#pragma mark -
#pragma mark DataViewDelegate methods

- (void)refreshView
{
	newTweetViewController.tweetUrl = tweetUrl;
	newTweetViewController.tweetText = hashtag;
}

- (void)fetchData
{
	if (!arrayTweets)
	{
		self.twitterController = [TwitterController twitterController];
		twitterController.delegate = self;
		
		[twitterController fetchTweetsWithURL:tweetUrl];		
	}
}

- (void)reloadTableViewDataSource
{
	self.twitterController = [TwitterController twitterController];
	twitterController.delegate = self;
	
	[twitterController fetchTweetsWithURL:tweetUrl];
}


#pragma mark -
#pragma mark TwitterControllerDelegate methods

- (void)fetchTweetsDidFinishWithResults:(NSArray *)tweets
{
	[self performSelector:@selector(dataSourceDidFinishLoadingNewData) withObject:nil afterDelay:0.0f];
	
	self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
	self.arrayTweets = tweets;

	[self.tableView reloadData];
}


#pragma mark -
#pragma mark TwitterProfileImageDownloaderDelegate methods

- (void)profileImageDidLoad:(NSIndexPath *)indexPath
{
    TwitterProfileImageDownloader *profileImageDownloader = [imageDownloadsInProgress objectForKey:indexPath];
	
    if (profileImageDownloader != nil)
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:profileImageDownloader.indexPathInTableView];
        
        // Display the newly loaded image
        cell.imageView.image = profileImageDownloader.tweet.profileImage;
    }
}


#pragma mark -
#pragma mark UIScrollViewDelegate methods

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	// pass this delegate call on so the pull to refresh works
	[super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
	
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	Tweet *tweet = (Tweet *)[arrayTweets objectAtIndex:indexPath.row];
	tweetDetailsViewController.tweet = tweet;
	tweetDetailsViewController.tweetUrl = tweetUrl;
	tweetDetailsViewController.retweetUrl = retweetUrl;
	[self.navigationController pushViewController:tweetDetailsViewController animated:YES];
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (arrayTweets)
	{
		Tweet *tweet = (Tweet *)[arrayTweets objectAtIndex:indexPath.row];
		
		CGSize maxSize = CGSizeMake(self.tableView.frame.size.width - 63.0f, CGFLOAT_MAX);
		CGSize textSize = [tweet.text sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:maxSize lineBreakMode:UILineBreakModeWordWrap];
		return MAX(textSize.height + 26.0f, 58.0f);
	}
	else 
	{
		return 44.0f;
	}
}


#pragma mark -
#pragma mark UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdent = @"tweetCell";
	static NSString *PlaceholderCellIdentifier = @"PlaceholderCell";
    
    // add a placeholder cell while waiting on table data
    int tweetCount = [self.arrayTweets count];
	
	if (tweetCount == 0 && indexPath.row == 0)
	{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PlaceholderCellIdentifier];
		
        if (cell == nil)
		{
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:PlaceholderCellIdentifier] autorelease];
            cell.detailTextLabel.textAlignment = UITextAlignmentCenter;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
		
		cell.detailTextLabel.text = @"Loading Tweets…";
		
		return cell;
    }
	
	TweetTableViewCell *cell = (TweetTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdent];
	
	if (cell == nil)
	{
		cell = [[[TweetTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdent] autorelease];
	}
		
	// Leave cells empty if there's no data yet
    if (tweetCount > 0)
	{
        Tweet *tweet = (Tweet *)[arrayTweets objectAtIndex:indexPath.row];
		
        // Only load cached images; defer new downloads until scrolling ends
        if (!tweet.profileImage)
        {
            if (tableView.dragging == NO && tableView.decelerating == NO)
            {
                [self startImageDownload:tweet forIndexPath:indexPath];
            }
        }

		cell.tweet = tweet;
    }	
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (arrayTweets)
	{
		return [arrayTweets count];
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
	
	self.title = @"Tweets";
	
	self.newTweetViewController = [[NewTweetViewController alloc] initWithNibName:nil bundle:nil];
	self.tweetDetailsViewController = [[TweetDetailsViewController alloc] initWithNibName:nil bundle:nil];
	
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
	self.imageDownloadsInProgress = nil;
	self.twitterController = nil;
	self.tweetUrl = nil;
	self.retweetUrl = nil;
	self.hashtag = nil;
	self.newTweetViewController = nil;
	self.tweetDetailsViewController = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[tweetUrl release];
	[retweetUrl release];
	[hashtag release];
	[newTweetViewController release];
	[tweetDetailsViewController release];
	
    [super dealloc];
}


@end
