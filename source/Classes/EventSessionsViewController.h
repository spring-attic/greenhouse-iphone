//
//  EventSessionsViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 8/2/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "EventSession.h"
#import "EventSessionDetailsViewController.h"


@interface EventSessionsViewController : OAuthViewController <UITableViewDelegate, UITableViewDataSource, DataViewDelegate> 
{

}

@property (nonatomic, retain) NSMutableArray *arraySessions;
@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) IBOutlet UITableView *tableViewSessions;
@property (nonatomic, retain) EventSessionDetailsViewController *sessionDetailsViewController;

- (void)refreshView;
- (void)fetchData;
- (EventSession *)eventSessionForIndexPath:(NSIndexPath *)indexPath;
- (BOOL)displayLoadingCell;

@end
