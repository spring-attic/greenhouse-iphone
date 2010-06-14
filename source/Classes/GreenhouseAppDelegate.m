//
//  GreenhouseAppDelegate.m
//  Greenhouse
//
//  Created by Roy Clarkson on 6/7/10.
//  Copyright VMware, Inc. 2010. All rights reserved.
//

#import "GreenhouseAppDelegate.h"
#import "OAuthManager.h"


@interface GreenhouseAppDelegate (PrivateCoreDataStack)

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end


@implementation GreenhouseAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (void)showAuthorizedViewController
{
	if (_authorizeViewController)
	{	
		[_authorizeViewController.view removeFromSuperview];
		[_authorizeViewController release];
	}
	
	[_window addSubview:_tabBarController.view];
}


#pragma mark -
#pragma mark UIApplicationDelegate methods

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
	if ([[OAuthManager sharedInstance] isAuthorized])
	{
		[_window addSubview:_tabBarController.view];
	}
	else 
	{
		_authorizeViewController = [[[AuthorizeViewController alloc] initWithNibName:@"AuthorizeViewController" bundle:nil] retain];
		[_window addSubview:_authorizeViewController.view];
	}
	
    [_window makeKeyAndVisible];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url 
{
	OAuthManager *mgr = [OAuthManager sharedInstance];
	mgr.delegate = self;
	mgr.selector = @selector(showAuthorizedViewController);
	[mgr processOauthResponse:url];
	
	return YES;
}

/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application 
{    
    NSError *error = nil;
	
    if (_managedObjectContext != nil) 
	{
        if ([_managedObjectContext hasChanges] && ![_managedObjectContext save:&error]) 
		{
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext 
{    
    if (_managedObjectContext != nil) 
	{
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	
    if (coordinator != nil) 
	{
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
	
    return _managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel 
{    
    if (_managedObjectModel != nil) 
	{
        return _managedObjectModel;
    }
	
    _managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return _managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator 
{    
    if (_persistentStoreCoordinator != nil) 
	{
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeUrl = [NSURL fileURLWithPath: [[AppSettings applicationDocumentsDirectory] stringByAppendingPathComponent: @"Greenhouse.sqlite"]];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
	if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) 
	{
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible
         * The schema for the persistent store is incompatible with current managed object model
         Check the error message to determine what the actual problem was.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{    
    [_managedObjectContext release];
    [_managedObjectModel release];
    [_persistentStoreCoordinator release];
    [_tabBarController release];
    [_window release];
	
    [super dealloc];
}

@end

