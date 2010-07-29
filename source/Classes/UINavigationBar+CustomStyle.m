//
//  UINavigationBar+CustomStyle.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/29/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "UINavigationBar+CustomStyle.h"


@implementation UINavigationBar (UINavigationBar_CustomStyle)

- (void)drawRect:(CGRect)rect 
{
	UIColor *color = [UIColor springDarkGreenColor];
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColor(context, CGColorGetComponents([color CGColor]));
	CGContextFillRect(context, rect);
	self.tintColor = color;
}

@end
