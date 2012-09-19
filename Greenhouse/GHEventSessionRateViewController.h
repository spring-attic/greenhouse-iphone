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
//  GHEventSessionRateViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 8/2/10.
//

#import <UIKit/UIKit.h>
#import "GHEventSessionRateDelegate.h"

@class Event;
@class EventSession;
@class GHEventSessionDetailsViewController;

@interface GHEventSessionRateViewController : UIViewController <GHEventSessionRateDelegate, UITextViewDelegate>

@property (nonatomic, strong) Event *event;
@property (nonatomic, strong) EventSession *session;
@property (nonatomic, strong) GHEventSessionDetailsViewController *sessionDetailsViewController;
@property (nonatomic, strong) IBOutlet UIButton *buttonRating1;
@property (nonatomic, strong) IBOutlet UIButton *buttonRating2;
@property (nonatomic, strong) IBOutlet UIButton *buttonRating3;
@property (nonatomic, strong) IBOutlet UIButton *buttonRating4;
@property (nonatomic, strong) IBOutlet UIButton *buttonRating5;
@property (nonatomic, strong) IBOutlet UITextView *textViewComments;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *barButtonCancel;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *barButtonSubmit;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *barButtonCount;

- (IBAction)actionSelectRating:(id)sender;
- (IBAction)actionCancel:(id)sender;
- (IBAction)actionSubmit:(id)sender;

@end
