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
    NSManagedObjectModel *_managedObjectModel;
    NSManagedObjectContext *_managedObjectContext;
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
	UITabBarController *_tabBarController;
    UIWindow *_window;
	AuthorizeViewController *_authorizeViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

- (NSString *)applicationDocumentsDirectory;

@end

