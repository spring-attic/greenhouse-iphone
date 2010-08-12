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


@implementation ProfileMainViewController

@synthesize labelDisplayName;
@synthesize imageViewPicture;

- (IBAction)actionSignOut:(id)sender
{
	[[OAuthManager sharedInstance] removeAccessToken];
	[appDelegate showAuthorizeViewController];
}

- (void)refreshView
{
	
}

- (void)fetchData
{
	[self fetchJSONDataWithURL:[NSURL URLWithString:MEMBER_PROFILE_URL]];
}

- (void)fetchRequest:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	if (ticket.didSucceed)
	{
		NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSDictionary *dictionary = [responseBody JSONValue];
		[responseBody release];
		
		DLog(@"%@", dictionary); 
		
		Profile *profile = [[Profile alloc] initWithDictionary:dictionary];
		
		labelDisplayName.text = profile.displayName;
		imageViewPicture.imageUrl = profile.pictureUrl;
		[imageViewPicture startImageDownload];
		
		[profile release];
	}
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
	
	[self fetchData];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.labelDisplayName = nil;
	self.imageViewPicture = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[labelDisplayName release];
	[imageViewPicture release];
	
    [super dealloc];
}


@end
