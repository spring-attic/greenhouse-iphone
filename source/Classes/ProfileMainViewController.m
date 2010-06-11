    //
//  ProfileMainViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 6/7/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "ProfileMainViewController.h"
#import "OAuthManager.h"


@implementation ProfileMainViewController

@synthesize textView = _textView;

- (void)showProfileDetails:(NSString *)details
{
	_textView.text = details;
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	OAuthManager *mgr = [OAuthManager sharedInstance];
	mgr.delegate = self;
	mgr.selector = @selector(showProfileDetails:);
	[mgr fetchProfileDetails];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.textView = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[_textView release];
	
    [super dealloc];
}


@end
