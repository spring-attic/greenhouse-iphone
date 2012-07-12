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
//  EventSessionsMenuViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/29/10.
//

#import <UIKit/UIKit.h>
#import "Event.h"


@class EventSessionsCurrentViewController;
@class EventSessionsFavoritesViewController;
@class EventSessionsConferenceFavoritesViewController;
@class EventSessionsByDayViewController;


@interface EventSessionsMenuViewController : DataViewController <UITableViewDelegate, UITableViewDataSource>
{

}

@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) IBOutlet UITableView *tableViewMenu;
@property (nonatomic, retain) EventSessionsCurrentViewController *sessionsCurrentViewController;
@property (nonatomic, retain) EventSessionsFavoritesViewController *sessionsFavoritesViewController;
@property (nonatomic, retain) EventSessionsConferenceFavoritesViewController *conferenceFavoritesViewController;
@property (nonatomic, retain) EventSessionsByDayViewController *sessionsByDayViewController;

@end
