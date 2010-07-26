//
//  EventTweetsViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/13/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"


@class NewTweetViewController;


@interface EventTweetsViewController : OAuthViewController <UITableViewDelegate, UITableViewDataSource> 
{

}

@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) IBOutlet UITableView *tableViewTweets;
@property (nonatomic, retain) IBOutlet NewTweetViewController *newTweetViewController;

@end
