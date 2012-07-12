//
//  Copyright 2010-2012 the original author or authors.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//
//  CustomTabBar.m
//  Greenhouse
//
//  Created by Roy Clarkson on 10/5/10.
//

#import "CustomTabBar.h"


@implementation CustomTabBar


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
	
    UIColor *color = [UIColor springDarkGreenColor];
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColor(context, CGColorGetComponents(color.CGColor));
	CGContextFillRect(context, rect);
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
    [super dealloc];
}


@end
