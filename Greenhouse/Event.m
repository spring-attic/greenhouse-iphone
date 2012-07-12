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
//  Event.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/8/10.
//

#import "Event.h"
#import "Venue.h"


@interface Event()

- (NSArray *)processVenueData:(NSArray *)venuesJson;

@end


@implementation Event

@synthesize eventId;
@synthesize title;
@synthesize startTime;
@synthesize endTime;
@synthesize location;
@synthesize description;
@synthesize name;
@synthesize hashtag;
@synthesize groupName;
@synthesize venues;


#pragma mark -
#pragma mark Private methods

- (NSArray *)processVenueData:(NSArray *)venuesJson
{
	if (venuesJson)
	{
		NSMutableArray *tmpVenues = [[NSMutableArray alloc] initWithCapacity:[venuesJson count]];
		
		for (NSDictionary *d in venuesJson)
		{
			Venue *venue = [[Venue alloc] initWithDictionary:d];
			[tmpVenues addObject:venue];
			[venue release];
		}
		
		NSArray *venuesArray = [NSArray arrayWithArray:tmpVenues];
		[tmpVenues release];
		
		return venuesArray;
	}
	
	return [NSArray array];
}


#pragma mark -
#pragma mark WebDataModel methods

- (id)initWithDictionary:(NSDictionary *)dictionary
{
	if ((self = [super init]))
	{
		if (dictionary)
		{
			self.eventId = [dictionary stringForKey:@"id"];
			self.title = [dictionary stringByReplacingPercentEscapesForKey:@"title" usingEncoding:NSUTF8StringEncoding];
			self.startTime = [dictionary dateWithMillisecondsSince1970ForKey:@"startTime"];
			self.endTime = [dictionary dateWithMillisecondsSince1970ForKey:@"endTime"];
			self.location = [dictionary stringByReplacingPercentEscapesForKey:@"location" usingEncoding:NSUTF8StringEncoding];
			self.description = [[dictionary stringForKey:@"description"] stringBySimpleXmlDecoding];
			self.name = [dictionary stringByReplacingPercentEscapesForKey:@"name" usingEncoding:NSUTF8StringEncoding];
			self.hashtag = [dictionary stringByReplacingPercentEscapesForKey:@"hashtag" usingEncoding:NSUTF8StringEncoding];
			self.groupName = [dictionary stringByReplacingPercentEscapesForKey:@"groupName" usingEncoding:NSUTF8StringEncoding];
			self.venues = [self processVenueData:[dictionary objectForKey:@"venues"]];
		}
	}
	
	return self;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc
{
	[eventId release];
	[title release];
	[startTime release];
	[endTime release];
	[location release];
	[description release];
	[name release];
	[hashtag release];
	[groupName release];
	[venues release];
	
	[super dealloc];
}

@end
