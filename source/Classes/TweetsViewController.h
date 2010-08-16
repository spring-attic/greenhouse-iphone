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


@interface TweetsViewController : OAuthViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, TweetProfileImageDownloaderDelegate, DataViewDelegate>
{

}

@property (nonatomic, retain) NSURL *tweetUrl;
@property (nonatomic, copy) NSString *hashtag;
@property (nonatomic, retain) IBOutlet UITableView *tableViewTweets;
@property (nonatomic, retain) IBOutlet NewTweetViewController *newTweetViewController;

- (void)refreshView;
- (void)fetchData;
- (void)profileImageDidLoad:(NSIndexPath *)indexPath;

@end
