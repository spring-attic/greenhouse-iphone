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
//  GHVenueAnnotation.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/27/10.
//

#import "GHVenueAnnotation.h"
#import "Venue.h"


@implementation GHVenueAnnotation

@synthesize venue;


#pragma mark -
#pragma mark Instance methods

- (id)initWithVenue:(Venue *)aVenue
{
	if ((self = [super init]))
	{
		self.venue = aVenue;
	}
	
	return self;
}


#pragma mark -
#pragma mark MKAnnotation methods

- (CLLocationCoordinate2D)coordinate
{
	if (venue)
	{
		coordinate = CLLocationCoordinate2DMake([venue.latitude doubleValue],
                                                [venue.longitude doubleValue]);
	}
	
	return coordinate;
}

- (NSString *)title
{
	if (venue)
	{
		return venue.name;
	}
	
	return @"";
}

- (NSString *)subtitle
{
	if (venue)
	{
		return venue.locationHint;
	}
	
	return @"";
}

@end
