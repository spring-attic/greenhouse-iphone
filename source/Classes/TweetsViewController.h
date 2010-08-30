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


@class NewTweetViewController;
@class TweetDetailsViewController;


@interface TweetsViewController : PullRefreshTableViewController <TwitterControllerDelegate, TwitterProfileImageDownloaderDelegate>
{

}

@property (nonatomic, retain) NSURL *tweetUrl;
@property (nonatomic, retain) NSURL *retweetUrl;
@property (nonatomic, copy) NSString *hashtag;
@property (nonatomic, retain) NewTweetViewController *newTweetViewController;
@property (nonatomic, retain) TweetDetailsViewController *tweetDetailsViewController;

- (void)refreshView;
- (void)profileImageDidLoad:(NSIndexPath *)indexPath;

@end
