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
//  EventSession.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/21/10.
//

#import "EventSession.h"
#import "EventSessionLeader.h"
#import "VenueRoom.h"


@interface EventSession()

- (NSArray *)processLeaderData:(NSArray *)leadersJson;

@end


@implementation EventSession

@synthesize number;
@synthesize title;
@synthesize startTime;
@synthesize endTime;
@synthesize description;
@synthesize leaders;
@synthesize hashtag;
@synthesize isFavorite;
@synthesize rating;
@synthesize room;
@dynamic leaderCount;
@dynamic leaderDisplay;


#pragma mark -
#pragma mark Public methods

- (NSInteger)leaderCount
{
	if (leaders)
	{
		return [leaders count];
	}
	
	return 0;
}

- (NSString *)leaderDisplay
{
	if (leaders)
	{
		return [self.leaders componentsJoinedByString:@", "];
	}
	
	return @"";
}


#pragma mark -
#pragma mark Private methods

- (NSArray *)processLeaderData:(NSArray *)leadersJson
{
	if (leadersJson)
	{
		NSMutableArray *tmpLeaders = [[NSMutableArray alloc] initWithCapacity:[leadersJson count]];
		
		for (NSDictionary *d in leadersJson) 
		{
			EventSessionLeader *leader = [[EventSessionLeader alloc] initWithDictionary:d];
			[tmpLeaders addObject:leader];
			[leader release];
		}
		
		NSArray *leadersArray = [NSArray arrayWithArray:tmpLeaders];
		[tmpLeaders release];
		
		return leadersArray;
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
			self.number = [dictionary stringForKey:@"number"];
			self.title = [dictionary stringByReplacingPercentEscapesForKey:@"title" usingEncoding:NSUTF8StringEncoding];
			self.startTime = [dictionary dateWithMillisecondsSince1970ForKey:@"startTime"];
			self.endTime = [dictionary dateWithMillisecondsSince1970ForKey:@"endTime"];
			self.description = [[dictionary stringForKey:@"description"] stringBySimpleXmlDecoding];
			self.leaders = [self processLeaderData:[dictionary objectForKey:@"leaders"]];
			self.hashtag = [dictionary stringByReplacingPercentEscapesForKey:@"hashtag" usingEncoding:NSUTF8StringEncoding];
			self.isFavorite = [dictionary boolForKey:@"favorite"];
			self.rating = [dictionary doubleForKey:@"rating"];
			
			VenueRoom *venueRoom = [[VenueRoom alloc] initWithDictionary:[dictionary objectForKey:@"room"]];
			self.room = venueRoom;
			[venueRoom release];
		}
	}
	
	return self;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc
{
	[number release];
	[title release];
	[startTime release];
	[endTime release];
	[description release];
	[leaders release];
	[hashtag release];
	[room release];
	
	[super dealloc];
}

@end
