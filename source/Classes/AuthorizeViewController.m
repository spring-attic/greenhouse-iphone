    //
//  AuthorizeViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 6/7/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "AuthorizeViewController.h"
#import "OAuthManager.h"


@implementation AuthorizeViewController

- (IBAction)actionAuthorize:(id)sender
{
	[[OAuthManager sharedInstance] fetchUnauthorizedRequestToken];
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
}


#pragma mark -
#pragma NSObject methods

- (void)dealloc 
{
    [super dealloc];
}

@end
