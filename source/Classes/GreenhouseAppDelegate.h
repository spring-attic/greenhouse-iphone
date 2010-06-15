//
//  GreenhouseAppDelegate.h
//  Greenhouse
//
//  Created by Roy Clarkson on 6/7/10.
//  Copyright VMware, Inc. 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AuthorizeViewController.h"


@interface GreenhouseAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> 
{
	
@private
    NSManagedObjectModel *_managedObjectModel;
    NSManagedObjectContext *_managedObjectContext;
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
    UIWindow *_window;
	UITabBarController *_tabBarController;
	AuthorizeViewController *_authorizeViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet AuthorizeViewController *authorizeViewController;

- (void)showAuthorizeViewController;
- (void)showMainViewController;

@end

