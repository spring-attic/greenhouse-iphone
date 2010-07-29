    //
//  MainViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 6/21/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "MainViewController.h"


@implementation MainViewController

@synthesize tabBarController = tabBarController;


#pragma mark -
#pragma mark UITabBarControllerDelegate methods

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
	[viewController viewDidAppear:YES];
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	[self.view addSubview:tabBarController.view];
	
	// the tabBarController gets confused about where to draw itself
	CGRect frame = tabBarController.view.frame;
	frame.origin.y = -20.0f;
	tabBarController.view.frame = frame;
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.tabBarController = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[tabBarController release];
	
    [super dealloc];
}


@end
