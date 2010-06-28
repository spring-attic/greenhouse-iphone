//
//  MainViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 6/21/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileMainViewController.h"


@interface MainViewController : UIViewController <UITabBarControllerDelegate>
{

@private
	UITabBarController *_tabBarController;
	ProfileMainViewController *_profileMainViewController;
}

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet ProfileMainViewController *profileMainViewController;

@end
