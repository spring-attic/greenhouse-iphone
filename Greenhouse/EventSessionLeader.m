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
//  EventSessionLeader.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/11/10.
//

#import "EventSessionLeader.h"


@implementation EventSessionLeader

@synthesize firstName;
@synthesize lastName;
@dynamic displayName;


#pragma mark -
#pragma mark WebDataModel methods

- (id)initWithDictionary:(NSDictionary *)dictionary
{
	if ((self = [super init]))
	{
		if (dictionary)
		{
			self.firstName = [dictionary stringByReplacingPercentEscapesForKey:@"firstName" usingEncoding:NSUTF8StringEncoding];
			self.lastName = [dictionary stringByReplacingPercentEscapesForKey:@"lastName" usingEncoding:NSUTF8StringEncoding];
		}
	}
	
	return self;
}

- (NSString *)displayName
{
	return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}


#pragma mark -
#pragma mark NSObject methods

- (NSString *)description
{
	return self.displayName;
}

- (void)dealloc
{
	[firstName release];
	[lastName release];
	
	[super dealloc];
}

@end
