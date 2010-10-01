//
//  EventSessionTweetsViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 9/13/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TweetsViewController.h"
#import "Event.h"
#import "EventSession.h"


@interface EventSessionTweetsViewController : TweetsViewController { }

@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) EventSession *session;

@end
