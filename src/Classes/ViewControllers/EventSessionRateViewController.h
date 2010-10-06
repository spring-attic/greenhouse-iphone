//
//  EventSessionRateViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 8/2/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventSessionController.h"


@class Event;
@class EventSession;


@interface EventSessionRateViewController : UIViewController <EventSessionControllerDelegate, UITextViewDelegate> { }

@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) EventSession *session;
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
