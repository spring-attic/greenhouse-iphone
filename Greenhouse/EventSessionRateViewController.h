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
//  EventSessionRateViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 8/2/10.
//

#import <UIKit/UIKit.h>
#import "EventSessionController.h"


@class Event;
@class EventSession;
@class EventSessionDetailsViewController;


@interface EventSessionRateViewController : UIViewController <EventSessionControllerDelegate, UITextViewDelegate> { }

@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) EventSession *session;
@property (nonatomic, retain) EventSessionDetailsViewController *sessionDetailsViewController;
@property (nonatomic, retain) IBOutlet UIButton *buttonRating1;
@property (nonatomic, retain) IBOutlet UIButton *buttonRating2;
@property (nonatomic, retain) IBOutlet UIButton *buttonRating3;
@property (nonatomic, retain) IBOutlet UIButton *buttonRating4;
@property (nonatomic, retain) IBOutlet UIButton *buttonRating5;
@property (nonatomic, retain) IBOutlet UITextView *textViewComments;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *barButtonCancel;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *barButtonSubmit;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *barButtonCount;

- (IBAction)actionSelectRating:(id)sender;
- (IBAction)actionCancel:(id)sender;
- (IBAction)actionSubmit:(id)sender;

@end
