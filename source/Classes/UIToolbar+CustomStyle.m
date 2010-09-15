//
//  UIToolbar+CustomStyle.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/3/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "UIToolbar+CustomStyle.h"


@implementation UIToolbar (UIToolbar_CustomStyle)

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
	[super drawLayer:layer inContext:ctx];

	// only modify the default bar behavior
	if (self.barStyle == UIBarStyleDefault)
	{
		UIColor *color = [UIColor springLightGreenColor];
		CGContextSetFillColor(ctx, CGColorGetComponents(color.CGColor));
		CGRect rect = CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
		CGContextFillRect(ctx, rect);
		self.tintColor = color;
		
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
}

@end
