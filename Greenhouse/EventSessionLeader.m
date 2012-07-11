//
//  EventSessionLeader.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/11/10.
//  Copyright 2010 VMware. All rights reserved.
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
