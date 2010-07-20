//
//  EventsNavigationViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/13/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@class EventsMainViewController;


@interface EventsNavigationViewController : UIViewController <UINavigationControllerDelegate> 
{

}

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet EventsMainViewController *eventsMainViewController;

@end
