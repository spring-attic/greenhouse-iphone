//
//  CustomNavigationBar.m
//  Greenhouse
//
//  Created by Roy Clarkson on 10/5/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "CustomNavigationBar.h"


@implementation CustomNavigationBar


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
	CGContextSetFillColor(context, CGColorGetComponents([color CGColor]));
	CGContextFillRect(context, rect);
	self.tintColor = color;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
    [super dealloc];
}


@end
