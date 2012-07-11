//
//  Venue.m
//  Greenhouse
//
//  Created by Roy Clarkson on 10/4/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "Venue.h"


@interface Venue()

- (CLLocation *)processLocationData:(NSDictionary *)locationJson;

@end


@implementation Venue

@synthesize venueId;
@synthesize location;
@synthesize locationHint;
@synthesize name;
@synthesize postalAddress;


#pragma mark -
#pragma mark Private methods

- (CLLocation *)processLocationData:(NSDictionary *)locationJson
{
	if (locationJson)
	{
		CLLocationDegrees latitude = [locationJson doubleForKey:@"latitude"];	
		CLLocationDegrees longitude = [locationJson doubleForKey:@"longitude"];
		return [[[CLLocation alloc] initWithLatitude:latitude longitude:longitude] autorelease];
	}
	
	return [[[CLLocation alloc] initWithLatitude:0.0f longitude:0.0f] autorelease];
}


#pragma mark -
#pragma mark WebDataModel methods

- (id)initWithDictionary:(NSDictionary *)dictionary
{
	if ((self = [super init]))
	{
		if (dictionary)
		{
			self.venueId = [dictionary stringForKey:@"id"];
			self.location = [self processLocationData:[dictionary objectForKey:@"location"]];
			self.locationHint = [dictionary stringForKey:@"locationHint"];
			self.name = [dictionary stringForKey:@"name"];
			self.postalAddress = [dictionary stringForKey:@"postalAddress"];
		}
	}
	
	return self;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc
{
	[venueId release];
	[location release];
	[locationHint release];
	[name release];
	[postalAddress release];
	
	[super dealloc];
}

@end
