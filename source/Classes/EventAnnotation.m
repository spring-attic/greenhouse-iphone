//
//  EventAnnotation.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/27/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "EventAnnotation.h"


@implementation EventAnnotation

@synthesize event;

- (CLLocationCoordinate2D)coordinate
{
	return coordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
	coordinate = newCoordinate;
}

- (NSString *)title
{
	if (event)
	{
		return event.title;
	}
	
	return @"";
}

//- (NSString *)subtitle
//{
//
//}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc
{
	[event release];
	
	[super dealloc];
}

@end
