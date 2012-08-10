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
//  GHVenue.m
//  Greenhouse
//
//  Created by Roy Clarkson on 10/4/10.
//

#import "GHVenue.h"


@interface GHVenue()

- (CLLocation *)processLocationData:(NSDictionary *)locationJson;

@end


@implementation GHVenue

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
		return [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
	}
	
	return [[CLLocation alloc] initWithLatitude:0.0f longitude:0.0f];
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

@end
