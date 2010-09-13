//
//  EventTweetsViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 9/12/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TweetsViewController.h"
#import "Event.h"


@interface EventTweetsViewController : TweetsViewController { }

@property (nonatomic, retain) Event *event;

@end
