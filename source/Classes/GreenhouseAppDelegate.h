//
//  GreenhouseAppDelegate.h
//  Greenhouse
//
//  Created by Roy Clarkson on 6/7/10.
//  Copyright VMware, Inc. 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@class MainViewController;
@class AuthorizeViewController;

@interface GreenhouseAppDelegate : NSObject <UIApplicationDelegate> 
{
	
@private
    NSManagedObjectModel *_managedObjectModel;
    NSManagedObjectContext *_managedObjectContext;
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
    UIWindow *_window;
	UIView *_viewStart;
	MainViewController *_mainViewController;
	AuthorizeViewController *_authorizeViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIView *viewStart;
@property (nonatomic, retain) IBOutlet MainViewController *mainViewController;
@property (nonatomic, retain) IBOutlet AuthorizeViewController *authorizeViewController;

- (void)showAuthorizeViewController;
- (void)showMainViewController;

@end

