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


@class EventSessionDescriptionViewController;
@class TweetsViewController;
@class EventSessionRateViewController;


@interface EventSessionDetailsViewController : UIViewController <DataViewDelegate, UITableViewDataSource, UITableViewDelegate>
{

}

@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) EventSession *session;
@property (nonatomic, retain) NSArray *arrayMenuItems;
@property (nonatomic, retain) IBOutlet UILabel *labelTitle;
@property (nonatomic, retain) IBOutlet UILabel *labelLeader;
@property (nonatomic, retain) IBOutlet UILabel *labelTime;
@property (nonatomic, retain) IBOutlet UIImageView *imageViewRating1;
@property (nonatomic, retain) IBOutlet UIImageView *imageViewRating2;
@property (nonatomic, retain) IBOutlet UIImageView *imageViewRating3;
@property (nonatomic, retain) IBOutlet UIImageView *imageViewRating4;
@property (nonatomic, retain) IBOutlet UIImageView *imageViewRating5;
@property (nonatomic, retain) IBOutlet UITableView *tableViewMenu;
@property (nonatomic, retain) EventSessionDescriptionViewController *sessionDescriptionViewController;
@property (nonatomic, retain) TweetsViewController *tweetsViewController;
@property (nonatomic, retain) EventSessionRateViewController *sessionRateViewController;

- (void)refreshView;
- (void)fetchData;

@end
