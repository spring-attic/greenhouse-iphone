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
//  GHEventDetailsViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/13/10.
//

#import <UIKit/UIKit.h>
#import "GHEvent.h"


@class GHEventDescriptionViewController;
@class GHEventSessionsMenuViewController;
@class GHEventTweetsViewController;
@class GHEventMapViewController;


@interface GHEventDetailsViewController : GHDataViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) GHEvent *event;
@property (nonatomic, strong) IBOutlet UILabel *labelTitle;
@property (nonatomic, strong) IBOutlet UILabel *labelDescription;
@property (nonatomic, strong) IBOutlet UILabel *labelTime;
@property (nonatomic, strong) IBOutlet UILabel *labelLocation;
@property (nonatomic, strong) IBOutlet UITableView *tableViewMenu;
@property (nonatomic, strong) GHEventDescriptionViewController *eventDescriptionViewController;
@property (nonatomic, strong) GHEventSessionsMenuViewController *eventSessionsMenuViewController;
@property (nonatomic, strong) GHEventTweetsViewController *eventTweetsViewController;
@property (nonatomic, strong) GHEventMapViewController *eventMapViewController;

@end
