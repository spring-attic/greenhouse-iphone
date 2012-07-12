//
//  Copyright 2010-2012 the original author or authors.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//
//  EventSessionDetailsViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/21/10.
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
