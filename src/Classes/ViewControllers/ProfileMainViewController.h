//
//  ProfileMainViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 6/7/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileController.h"


@class Profile;
@class WebImageView;


@interface ProfileMainViewController : DataViewController <ProfileControllerDelegate> { }

@property (nonatomic, retain) Profile *profile;
@property (nonatomic, retain) IBOutlet UILabel *labelDisplayName;
@property (nonatomic, retain) IBOutlet WebImageView *imageViewPicture;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicatorView;

- (IBAction)actionSignOut:(id)sender;
- (IBAction)actionRefresh:(id)sender;

@end
