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
//  EventDetailsViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/13/10.
//

#import <UIKit/UIKit.h>
#import "Event.h"


@class EventDescriptionViewController;
@class EventSessionsMenuViewController;
@class EventTweetsViewController;
@class EventMapViewController;


@interface EventDetailsViewController : DataViewController <UITableViewDataSource, UITableViewDelegate> { }

@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) IBOutlet UILabel *labelTitle;
@property (nonatomic, retain) IBOutlet UILabel *labelDescription;
@property (nonatomic, retain) IBOutlet UILabel *labelTime;
@property (nonatomic, retain) IBOutlet UILabel *labelLocation;
@property (nonatomic, retain) IBOutlet UITableView *tableViewMenu;
@property (nonatomic, retain) EventDescriptionViewController *eventDescriptionViewController;
@property (nonatomic, retain) EventSessionsMenuViewController *eventSessionsMenuViewController;
@property (nonatomic, retain) EventTweetsViewController *eventTweetsViewController;
@property (nonatomic, retain) EventMapViewController *eventMapViewController;

@end
