//
//  OAuthSampleAppDelegate.h
//  OAuthSample
//
//  Created by Roy Clarkson on 5/27/10.
//  Copyright VMware 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthConsumer.h"


@class OAuthSampleViewController;

@interface OAuthSampleAppDelegate : NSObject <UIApplicationDelegate> 
{

@private
    UIWindow *_window;
    OAuthSampleViewController *_viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet OAuthSampleViewController *viewController;

@end

