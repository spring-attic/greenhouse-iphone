//
//  EventSessionsViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/30/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"


@class EventSessionDetailsViewController;

@interface EventSessionsViewController : OAuthViewController <UITableViewDelegate, UITableViewDataSource>
{

}

@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) NSDate *eventDate;
@property (nonatomic, retain) IBOutlet UITableView *tableViewSessions;
@property (nonatomic, retain) EventSessionDetailsViewController *sessionDetailsViewController;

@end
