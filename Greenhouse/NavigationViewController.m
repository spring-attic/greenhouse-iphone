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
//  NavigationViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/27/10.
//

#import "NavigationViewController.h"


@implementation NavigationViewController

@synthesize navigationController;

- (void)reloadData
{
	if ([navigationController.topViewController respondsToSelector:@selector(reloadData)])
	{
		[navigationController.topViewController performSelector:@selector(reloadData)];
	}	
}


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

@end
