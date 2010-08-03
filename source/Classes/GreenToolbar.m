//
//  GreenToolbar.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/3/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "GreenToolbar.h"


@interface GreenToolbar()

- (void)applyStyling;

@end


@implementation GreenToolbar


- (void)applyStyling
{
	self.tintColor = [UIColor springDarkGreenColor];

	// warning, workaround ahead...
	// The tint is not being applied correctly to UIBarButtonItems
	// see http://www.openradar.me/8121374
	for (UIBarButtonItem *item in self.items)
	{
		if (item.style == UIBarButtonItemStyleBordered)
		{
			item.style = UIBarButtonItemStylePlain;
			item.style = UIBarButtonItemStyleBordered;
		}
	}
}


#pragma mark -
#pragma mark NSCoding methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
	{
		[self applyStyling];
	}
	
	return self;	
}


#pragma mark -
#pragma mark UIView methods

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
		[self applyStyling];
	}
	
	return self;
}

@end
