//
//  EventSessionDetailsViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/21/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventSessionController.h"


@class Event;
@class EventSession;
@class EventSessionDescriptionViewController;
@class EventSessionTweetsViewController;
@class EventSessionRateViewController;


@interface EventSessionDetailsViewController : DataViewController <UITableViewDataSource, UITableViewDelegate, EventSessionControllerDelegate> { }

@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) EventSession *session;
@property (nonatomic, retain) NSArray *arrayMenuItems;
@property (nonatomic, retain) IBOutlet UILabel *labelTitle;
@property (nonatomic, retain) IBOutlet UILabel *labelLeader;
@property (nonatomic, retain) IBOutlet UILabel *labelTime;
@property (nonatomic, retain) IBOutlet UILabel *labelLocation;
@property (nonatomic, retain) IBOutlet UIImageView *imageViewRating1;
@property (nonatomic, retain) IBOutlet UIImageView *imageViewRating2;
@property (nonatomic, retain) IBOutlet UIImageView *imageViewRating3;
@property (nonatomic, retain) IBOutlet UIImageView *imageViewRating4;
@property (nonatomic, retain) IBOutlet UIImageView *imageViewRating5;
@property (nonatomic, retain) IBOutlet UITableView *tableViewMenu;
@property (nonatomic, retain) EventSessionDescriptionViewController *sessionDescriptionViewController;
@property (nonatomic, retain) EventSessionTweetsViewController *sessionTweetsViewController;
@property (nonatomic, retain) EventSessionRateViewController *sessionRateViewController;

- (void)updateRating:(double)newRating;

@end
