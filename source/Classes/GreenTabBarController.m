//
//  GreenTabBarController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/22/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "GreenTabBarController.h"


@implementation GreenTabBarController


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
	[super viewDidLoad];
	
	CGRect frame = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height);
	UIView *viewBackground = [[UIView alloc] initWithFrame:frame];
	viewBackground.backgroundColor = [UIColor springDarkGreenColor];
	viewBackground.alpha = 0.9f;
	[self.tabBar insertSubview:viewBackground atIndex:0];
	[viewBackground release];
}


@end
