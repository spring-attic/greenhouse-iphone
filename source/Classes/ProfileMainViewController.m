    //
//  ProfileMainViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 6/7/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "ProfileMainViewController.h"
#import "OAuthManager.h"
#import "Profile.h"


@interface ProfileMainViewController()

@property (nonatomic, retain) ProfileController *profileController;

@end


@implementation ProfileMainViewController

@synthesize profileController;
@synthesize labelDisplayName;
@synthesize imageViewPicture;

- (IBAction)actionSignOut:(id)sender
{
	[[OAuthManager sharedInstance] removeAccessToken];
	[appDelegate showAuthorizeViewController];
}


#pragma mark -
#pragma mark ProfileControllerDelegate methods

- (void)fetchProfileDidFinishWithResults:(Profile *)profile;
{
	self.profileController = nil;
	
	labelDisplayName.text = profile.displayName;
	imageViewPicture.imageUrl = profile.imageUrl;
	[imageViewPicture startImageDownload];
}

- (void)fetchProfileDidFailWithError:(NSError *)error
{
	self.profileController = nil;
}


#pragma mark -
#pragma mark DataViewController methods

- (void)reloadData
{
	self.profileController = [ProfileController profileController];
	profileController.delegate = self;
	
	[profileController fetchProfile];
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[self reloadData];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.profileController = nil;
	self.labelDisplayName = nil;
	self.imageViewPicture = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[profileController release];
	[labelDisplayName release];
	[imageViewPicture release];
	
    [super dealloc];
}


@end
