//
//  ProfileController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 9/7/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthController.h"
#import "ProfileControllerDelegate.h"


@interface ProfileController : OAuthController 
{ 
	id<ProfileControllerDelegate> _delegate;
}

@property (nonatomic, assign) id<ProfileControllerDelegate> delegate;

+ (ProfileController *)profileController;

- (void)fetchProfile;
- (void)fetchProfile:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
- (void)fetchProfile:(OAServiceTicket *)ticket didFailWithError:(NSError *)error;

@end