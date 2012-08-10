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
//  GHProfile.m
//  Greenhouse
//
//  Created by Roy Clarkson on 6/11/10.
//

#import "GHProfile.h"


@implementation GHProfile

@synthesize accountId;
@synthesize displayName;
@synthesize imageUrl;


#pragma mark -
#pragma mark Static methods

+ (GHProfile *)profileWithDictionary:(NSDictionary *)dictionary
{
	return [[GHProfile alloc] initWithDictionary:dictionary];
}


#pragma mark -
#pragma mark WebDataModel methods

- (id)initWithDictionary:(NSDictionary *)dictionary
{
	if ((self = [super init]))
	{
		if (dictionary)
		{
			self.accountId = [dictionary integerForKey:@"accountId"];
			self.displayName = [dictionary stringByReplacingPercentEscapesForKey:@"displayName" usingEncoding:NSUTF8StringEncoding];
			self.imageUrl = [dictionary urlForKey:@"pictureUrl"];
		}
	}
	
	return self;
}


#pragma mark -
#pragma mark NSObject methods

- (NSString *)description
{
	return self.displayName;
}

@end
