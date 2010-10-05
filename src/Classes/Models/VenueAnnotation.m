//
//  VenueAnnotation.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/27/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "VenueAnnotation.h"
#import "Venue.h"


@implementation VenueAnnotation

@synthesize venue = _venue;


#pragma mark -
#pragma mark Instance methods

- (id)initWithVenue:(Venue *)venue
{
	if ((self = [super init]))
	{
		self.venue = venue;
	}
	
	return self;
}


#pragma mark -
#pragma mark MKAnnotation methods

- (CLLocationCoordinate2D)coordinate
{
	if (_venue)
	{
		_coordinate = _venue.location.coordinate;
	}
	
	return _coordinate;
}

- (NSString *)title
{
	if (_venue)
	{
		return _venue.name;
	}
	
	return @"";
}

- (NSString *)subtitle
{
	if (_venue)
	{
		return _venue.locationHint;
	}
	
	return @"";
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc
{
	[_venue release];
	
	[super dealloc];
}

@end
