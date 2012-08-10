//
//  Copyright 2010-2012 the original author or authors.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//
//  GHProfileMainViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 6/7/10.
//

#import "GHProfileMainViewController.h"
#import "GHOAuthManager.h"
#import "GHProfile.h"
#import "GHWebImageView.h"


@interface GHProfileMainViewController()

@property (nonatomic, strong) GHProfileController *profileController;

@end


@implementation GHProfileMainViewController

@synthesize profile;
@synthesize profileController;
@synthesize labelDisplayName;
@synthesize imageViewPicture;
@synthesize activityIndicatorView;


#pragma mark -
#pragma mark Public methods

- (IBAction)actionSignOut:(id)sender
{
	[[GHOAuthManager sharedInstance] removeAccessToken];
	[appDelegate showAuthorizeViewController];
}

- (IBAction)actionRefresh:(id)sender
{
	self.profile = nil;

	[self reloadData];
}


#pragma mark -
#pragma mark ProfileControllerDelegate methods

- (void)fetchProfileDidFinishWithResults:(GHProfile *)newProfile;
{
	[activityIndicatorView stopAnimating];
	self.profileController = nil;
	self.profile = newProfile;
	
	labelDisplayName.text = profile.displayName;
	
	imageViewPicture.imageUrl = profile.imageUrl;
	[imageViewPicture startImageDownload];
}

- (void)fetchProfileDidFailWithError:(NSError *)error
{
	[activityIndicatorView stopAnimating];
	self.profileController = nil;
}


#pragma mark -
#pragma mark DataViewController methods

- (void)reloadData
{
	if ([self shouldReloadData])
	{
		[activityIndicatorView startAnimating];
		
		self.profileController = [[GHProfileController alloc] init];
		profileController.delegate = self;
		
		[profileController fetchProfile];
	}
}

- (BOOL)shouldReloadData
{
	return (!profile);
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	activityIndicatorView.hidesWhenStopped = YES;
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
	self.profile = nil;
	self.labelDisplayName = nil;
	self.imageViewPicture = nil;
	self.activityIndicatorView = nil;
}

@end
