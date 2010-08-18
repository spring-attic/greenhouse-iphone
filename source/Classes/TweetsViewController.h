//
//  TweetsViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/26/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetProfileImageDownloader.h"


@class NewTweetViewController;
@class TweetDetailsViewController;


@interface TweetsViewController : OAuthViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, TweetProfileImageDownloaderDelegate, DataViewDelegate>
{

}

@property (nonatomic, retain) NSURL *tweetUrl;
@property (nonatomic, copy) NSString *hashtag;
@property (nonatomic, retain) IBOutlet UITableView *tableViewTweets;
@property (nonatomic, retain) NewTweetViewController *newTweetViewController;
@property (nonatomic, retain) TweetDetailsViewController *tweetDetailsViewController;

- (void)refreshView;
- (void)fetchData;
- (void)profileImageDidLoad:(NSIndexPath *)indexPath;

@end
