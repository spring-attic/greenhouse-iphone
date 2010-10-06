//
//  CustomToolbar.m
//  Greenhouse
//
//  Created by Roy Clarkson on 10/5/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "CustomToolbar.h"


@implementation CustomToolbar


#pragma mark -
#pragma mark UIView methods

- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) 
	{
        // Initialization code
    }
	
    return self;
}

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	
	UIColor *color = [UIColor springLightGreenColor];
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColor(context, CGColorGetComponents(color.CGColor));
	CGContextFillRect(context, rect);
	self.tintColor = color;
	
	// warning, workaround ahead...
	// The tint is not being applied correctly to UIBarButtonItems
	// see http://www.openradar.me/8121374
	for (UIBarButtonItem *buttonItem in self.items)
	{		
		if ([buttonItem respondsToSelector:@selector(setTintColor:)]) 
		{
			[buttonItem performSelector:@selector(setTintColor:) withObject:color];
		}		
	}
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
    [super dealloc];
}


@end
