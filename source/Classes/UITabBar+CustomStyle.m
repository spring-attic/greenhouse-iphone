//
//  UITabBar+CustomStyle.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/12/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "UITabBar+CustomStyle.h"


@implementation UITabBar (UITabBar_CustomStyle)

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
	[super drawLayer:layer inContext:ctx];
	
	UIColor *color = [UIColor springDarkGreenColor];
	CGContextSetFillColor(ctx, CGColorGetComponents(color.CGColor));
	CGRect rect = CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
	CGContextFillRect(ctx, rect);
}

@end
