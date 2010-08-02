//
//  EventSessionsFavoritesViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 8/2/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"


@class EventSessionDetailsViewController;


@interface EventSessionsFavoritesViewController : OAuthViewController 
{

}

@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) IBOutlet UITableView *tableViewSessions;
@property (nonatomic, retain) EventSessionDetailsViewController *sessionDetailsViewController;

@end
