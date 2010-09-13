    //
//  NavigationViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/27/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "NavigationViewController.h"


@implementation NavigationViewController

@synthesize navigationController;

#pragma mark -
#pragma mark UINavigationControllerDelegate methods

- (void)navigationController:(UINavigationController *)navigationController 
	   didShowViewController:(UIViewController *)viewController 
					animated:(BOOL)animated
{
	if ([viewController respondsToSelector:@selector(reloadData)])
	{
		[viewController performSelector:@selector(reloadData)];
	}
}

- (void)navigationController:(UINavigationController *)navigationController 
	  willShowViewController:(UIViewController *)viewController 
					animated:(BOOL)animated
{
	if ([viewController respondsToSelector:@selector(refreshView)])
	{
		[viewController performSelector:@selector(refreshView)];
	}
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	[self.view addSubview:navigationController.view];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.navigationController = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[navigationController release];
	
    [super dealloc];
}

@end
