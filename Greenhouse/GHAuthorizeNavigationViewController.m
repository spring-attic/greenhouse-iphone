//
//  Copyright 2012 the original author or authors.
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
//  GHAuthorizeNavigationViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/30/12.
//

#import "GHAuthorizeNavigationViewController.h"

@interface GHAuthorizeNavigationViewController ()

@end

@implementation GHAuthorizeNavigationViewController

@synthesize navigationController;


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad
{
    [super viewDidLoad];

	// correct the layout of the subview
    navigationController.view.frame = self.view.bounds;
    
    // add the home screen view
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
