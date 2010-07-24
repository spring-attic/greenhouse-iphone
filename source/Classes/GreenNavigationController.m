//
//  GreenNavigationController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/22/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "GreenNavigationController.h"


@implementation GreenNavigationController


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.navigationBar.tintColor = [UIColor springDarkGreenColor];
}

@end
