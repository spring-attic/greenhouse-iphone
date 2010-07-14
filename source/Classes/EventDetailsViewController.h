//
//  EventDetailsViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/13/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"


@interface EventDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {

}

@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) IBOutlet UILabel *labelTitle;
@property (nonatomic, retain) IBOutlet UILabel *labelDescription;
@property (nonatomic, retain) IBOutlet UILabel *labelStartTime;
@property (nonatomic, retain) IBOutlet UILabel *labelEndTime;
@property (nonatomic, retain) IBOutlet UILabel *labelLocation;
@property (nonatomic, retain) IBOutlet UILabel *labelHashtag;
@property (nonatomic, retain) IBOutlet UITableView *tableViewMenu;

@end
