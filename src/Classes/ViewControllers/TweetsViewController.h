//
//  TweetsViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/26/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterController.h"
#import "TwitterProfileImageDownloader.h"
#import "PullRefreshTableViewController.h"
#import "NewTweetViewController.h"


@class TweetDetailsViewController;


@interface TweetsViewController : PullRefreshTableViewController <UITableViewDelegate, UITableViewDataSource, TwitterControllerDelegate, TwitterProfileImageDownloaderDelegate> 
{ 
	
@private
	BOOL _isLoading;
	NSUInteger _currentPage;
	BOOL _isLastPage;
}

@property (nonatomic, retain) NSMutableArray *arrayTweets;
@property (nonatomic, retain) NSURL *tweetUrl;
@property (nonatomic, retain) NSURL *retweetUrl;
@property (nonatomic, retain) NewTweetViewController *newTweetViewController;
@property (nonatomic, retain) TweetDetailsViewController *tweetDetailsViewController;
@property (nonatomic, assign) BOOL isLoading;

- (void)profileImageDidLoad:(NSIndexPath *)indexPath;

@end
