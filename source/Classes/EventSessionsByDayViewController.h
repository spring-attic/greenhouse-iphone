//
//  EventSessionsByDayViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/30/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventSessionsViewController.h"
#import "EventSessionController.h"


@interface EventSessionsByDayViewController : EventSessionsViewController <EventSessionControllerDelegate> { }

@property (nonatomic, retain) NSDate *eventDate;

@end
