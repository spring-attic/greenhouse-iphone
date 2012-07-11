//
//  EventSessionsViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 8/2/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullRefreshTableViewController.h"
#import "Event.h"
#import "EventSession.h"
#import "EventSessionDetailsViewController.h"


@interface EventSessionsViewController : PullRefreshTableViewController { }

@property (nonatomic, retain) NSArray *arraySessions;
@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) Event *currentEvent;
@property (nonatomic, retain) EventSessionDetailsViewController *sessionDetailsViewController;

- (EventSession *)eventSessionForIndexPath:(NSIndexPath *)indexPath;
- (BOOL)displayLoadingCell;

@end
