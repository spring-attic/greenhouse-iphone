//
//  Copyright 2010-2012 the original author or authors.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//
//  GHEventsMainViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/8/10.
//

#import <UIKit/UIKit.h>
#import "GHPullRefreshTableViewController.h"
#import "GHEventController.h"
#import "GHEventDetailsViewController.h"


@interface GHEventsMainViewController : GHPullRefreshTableViewController <UITableViewDelegate, UITableViewDataSource, GHEventControllerDelegate>

@property (nonatomic, strong) IBOutlet UIBarButtonItem *barButtonRefresh;
@property (nonatomic, strong) IBOutlet GHEventDetailsViewController *eventDetailsViewController;

@end
