//
//  EventsMainViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/8/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullRefreshTableViewController.h"
#import "EventController.h"
#import "EventDetailsViewController.h"


@interface EventsMainViewController : PullRefreshTableViewController <UITableViewDelegate, UITableViewDataSource, EventControllerDelegate> { }

@property (nonatomic, retain) IBOutlet UIBarButtonItem *barButtonRefresh;
@property (nonatomic, retain) IBOutlet EventDetailsViewController *eventDetailsViewController;

@end
