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
//  VenueRoom.m
//  Greenhouse
//
//  Created by Roy Clarkson on 10/5/10.
//

#import "VenueRoom.h"


@implementation VenueRoom

@synthesize roomId;
@synthesize label;
@synthesize venueId;


#pragma mark -
#pragma mark WebDataModel methods

- (id)initWithDictionary:(NSDictionary *)dictionary
{
	if ((self = [super init]))
	{
		if (dictionary)
		{
			self.roomId = [dictionary stringForKey:@"id"];
			self.label = [dictionary stringForKey:@"label"];
			self.venueId = [dictionary stringForKey:@"parentId"];
		}
	}
	
	return self;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc
{
	[roomId release];
	[label release];
	[venueId release];
	
	[super dealloc];
}
@end
