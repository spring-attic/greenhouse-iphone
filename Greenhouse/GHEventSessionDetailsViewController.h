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
//  GHEventSessionDetailsViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/21/10.
//

#import <UIKit/UIKit.h>
#import "GHEventSessionController.h"


@class GHEvent;
@class GHEventSession;
@class GHEventSessionDescriptionViewController;
@class GHEventSessionTweetsViewController;
@class GHEventSessionRateViewController;


@interface GHEventSessionDetailsViewController : GHDataViewController <UITableViewDataSource, UITableViewDelegate, GHEventSessionControllerDelegate> { }

@property (nonatomic, strong) GHEvent *event;
@property (nonatomic, strong) GHEventSession *session;
@property (nonatomic, strong) NSArray *arrayMenuItems;
@property (nonatomic, strong) IBOutlet UILabel *labelTitle;
@property (nonatomic, strong) IBOutlet UILabel *labelLeader;
@property (nonatomic, strong) IBOutlet UILabel *labelTime;
@property (nonatomic, strong) IBOutlet UILabel *labelLocation;
@property (nonatomic, strong) IBOutlet UIImageView *imageViewRating1;
@property (nonatomic, strong) IBOutlet UIImageView *imageViewRating2;
@property (nonatomic, strong) IBOutlet UIImageView *imageViewRating3;
@property (nonatomic, strong) IBOutlet UIImageView *imageViewRating4;
@property (nonatomic, strong) IBOutlet UIImageView *imageViewRating5;
@property (nonatomic, strong) IBOutlet UITableView *tableViewMenu;
@property (nonatomic, strong) GHEventSessionDescriptionViewController *sessionDescriptionViewController;
@property (nonatomic, strong) GHEventSessionTweetsViewController *sessionTweetsViewController;
@property (nonatomic, strong) GHEventSessionRateViewController *sessionRateViewController;

- (void)updateRating:(double)newRating;

@end
