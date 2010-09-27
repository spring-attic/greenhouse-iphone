//
//  UITabBar+CustomStyle.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/12/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "UITabBar+CustomStyle.h"


@implementation UITabBar (UITabBar_CustomStyle)

- (void)drawRect:(CGRect)rect
{
	UIColor *color = [UIColor springDarkGreenColor];
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColor(context, CGColorGetComponents(color.CGColor));
	CGContextFillRect(context, rect);
}

@end
