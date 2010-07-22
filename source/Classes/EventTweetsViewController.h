//
//  EventTweetsViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/13/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EventTweetsViewController : OAuthViewController <UITableViewDelegate, UITableViewDataSource> 
{

}

@property (nonatomic, assign) NSInteger eventId;
@property (nonatomic, retain) IBOutlet UITableView *tableViewTweets;

@end
