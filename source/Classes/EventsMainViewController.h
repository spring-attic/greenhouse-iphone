//
//  EventsMainViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/8/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventDetailsViewController.h"


@interface EventsMainViewController : OAuthViewController 
{

}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *barButtonRefresh;
@property (nonatomic, retain) IBOutlet UITableView *tableViewEvents;
@property (nonatomic, retain) IBOutlet EventDetailsViewController *eventDetailsViewController;

- (IBAction)actionRefresh:(id)sender;
- (void)refreshData;

@end
