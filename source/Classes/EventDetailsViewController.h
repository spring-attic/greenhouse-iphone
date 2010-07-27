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
@class EventCurrentSessionsViewController;
@class EventTweetsViewController;


@interface EventDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> 
{

}

@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) IBOutlet UILabel *labelTitle;
@property (nonatomic, retain) IBOutlet UILabel *labelDescription;
@property (nonatomic, retain) IBOutlet UILabel *labelTime;
@property (nonatomic, retain) IBOutlet UILabel *labelLocation;
@property (nonatomic, retain) IBOutlet UITableView *tableViewMenu;
@property (nonatomic, retain) EventDescriptionViewController *eventDescriptionViewController;
@property (nonatomic, retain) EventCurrentSessionsViewController *eventSessionsViewController;
@property (nonatomic, retain) EventTweetsViewController *eventTweetsViewController;

@end
