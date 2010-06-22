//
//  MainViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 6/21/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MainViewController : UIViewController <UITabBarControllerDelegate>
{

@private
	UITabBarController *_tabBarController;
}

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
