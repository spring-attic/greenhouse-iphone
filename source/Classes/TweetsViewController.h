//
//  TweetsViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/26/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import <UIKit/UIKit.h>


@class NewTweetViewController;


@interface TweetsViewController : OAuthViewController  <UITableViewDelegate, UITableViewDataSource>
{

}

@property (nonatomic, retain) NSURL *tweetUrl;
@property (nonatomic, copy) NSString *hashtag;
@property (nonatomic, retain) IBOutlet UITableView *tableViewTweets;
@property (nonatomic, retain) IBOutlet NewTweetViewController *newTweetViewController;

@end
