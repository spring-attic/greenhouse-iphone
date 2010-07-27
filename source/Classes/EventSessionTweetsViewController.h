//
//  EventSessionTweetsViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/26/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetsViewController.h"
#import "event.h"
#import "EventSession.h"


@interface EventSessionTweetsViewController : TweetsViewController 
{

}

@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) EventSession *session;

@end
