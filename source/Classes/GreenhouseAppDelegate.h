//
//  GreenhouseAppDelegate.h
//  Greenhouse
//
//  Created by Roy Clarkson on 6/7/10.
//  Copyright VMware, Inc. 2010. All rights reserved.
//

#import <UIKit/UIKit.h>


@class AuthorizeViewController;

@interface GreenhouseAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, UIAlertViewDelegate> { }

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet AuthorizeViewController *authorizeViewController;

- (void)showAuthorizeViewController;
- (void)showTabBarController;
- (void)reloadDataForCurrentView;
- (void)processOauthResponseDidFinish;
- (void)processOauthResponseDidFail;

@end

