//
//  EventSessionDetailsViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/21/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "EventSession.h"


@class EventSessionSummaryViewController;
@class EventSessionTweetsViewController;


@interface EventSessionDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{

}

@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) EventSession *session;
@property (nonatomic, retain) NSArray *arrayMenuItems;
@property (nonatomic, retain) IBOutlet UILabel *labelTitle;
@property (nonatomic, retain) IBOutlet UILabel *labelLeader;
@property (nonatomic, retain) IBOutlet UILabel *labelTime;
@property (nonatomic, retain) IBOutlet UITableView *tableViewMenu;
@property (nonatomic, retain) EventSessionSummaryViewController *sessionSummaryViewController;
@property (nonatomic, retain) EventSessionTweetsViewController *sessionTweetsViewController;

@end
