//
//  NavigationViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/27/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NavigationViewController : UIViewController <UINavigationControllerDelegate>
{

}

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end
