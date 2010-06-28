    //
//  MainViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 6/21/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "MainViewController.h"


@implementation MainViewController

@synthesize tabBarController = _tabBarController;
@synthesize profileMainViewController = _profileMainViewController;


#pragma mark -
#pragma mark UITabBarControllerDelegate methods


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	[self.view addSubview:_tabBarController.view];
	
	// the tabBarController gets confused about where to draw itself
	CGRect frame = _tabBarController.view.frame;
	frame.origin.y = -20.0f;
	_tabBarController.view.frame = frame;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	// pass the event along to the current tab
	[_tabBarController.selectedViewController viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.tabBarController = nil;
	self.profileMainViewController = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[_tabBarController release];
	[_profileMainViewController release];
	
    [super dealloc];
}


@end
