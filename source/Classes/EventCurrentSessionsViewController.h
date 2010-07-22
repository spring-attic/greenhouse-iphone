//
//  EventCurrentSessionsViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/13/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@class EventSessionDetailsViewController;


@interface EventCurrentSessionsViewController : OAuthViewController<UITableViewDelegate, UITableViewDataSource> 
{

}

@property (nonatomic, assign) NSInteger eventId;
@property (nonatomic, retain) EventSessionDetailsViewController *eventSessionDetailsViewController;
@property (nonatomic, retain) IBOutlet UITableView *tableViewSessions;

@end
