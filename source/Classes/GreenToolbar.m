//
//  GreenToolbar.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/23/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "GreenToolbar.h"


@implementation GreenToolbar

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
		self.tintColor = [UIColor springDarkGreenColor];
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
	{
		self.tintColor = [UIColor springDarkGreenColor];
	}
	
	return self;
}

@end
