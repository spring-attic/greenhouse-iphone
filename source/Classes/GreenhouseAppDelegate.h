//
//  GreenhouseAppDelegate.h
//  Greenhouse
//
//  Created by Roy Clarkson on 6/7/10.
//  Copyright VMware, Inc. 2010. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MainViewController;
@class AuthorizeViewController;

@interface GreenhouseAppDelegate : NSObject <UIApplicationDelegate> { }

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) MainViewController *mainViewController;
@property (nonatomic, retain) AuthorizeViewController *authorizeViewController;

- (void)showAuthorizeViewController;
- (void)showMainViewController;

@end

