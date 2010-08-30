//
//  EventDetailsViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/13/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"


@class EventDescriptionViewController;
@class EventSessionsMenuViewController;
@class TweetsViewController;
@class EventMapViewController;


@interface EventDetailsViewController : UIViewController <DataViewDelegate, UITableViewDataSource, UITableViewDelegate> 
{

}

@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) IBOutlet UILabel *labelTitle;
@property (nonatomic, retain) IBOutlet UILabel *labelDescription;
@property (nonatomic, retain) IBOutlet UILabel *labelTime;
@property (nonatomic, retain) IBOutlet UILabel *labelLocation;
@property (nonatomic, retain) IBOutlet UITableView *tableViewMenu;
@property (nonatomic, retain) EventDescriptionViewController *eventDescriptionViewController;
@property (nonatomic, retain) EventSessionsMenuViewController *eventSessionsMenuViewController;
@property (nonatomic, retain) TweetsViewController *tweetsViewController;
@property (nonatomic, retain) EventMapViewController *eventMapViewController;

- (void)refreshView;
- (void)fetchData;

@end
