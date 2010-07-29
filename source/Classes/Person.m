//
//  Person.m
//  Greenhouse
//
//  Created by Roy Clarkson on 6/11/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "Person.h"


@implementation Person

@synthesize firstName;
@synthesize lastName;
@dynamic displayName;

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
	return [NSString stringWithFormat:@"%@ %@", firstName, lastName];
}


#pragma mark -
#pragma mark NSObject methods

- (NSString *)description
{
	return [self displayName];
}

- (void)dealloc
{
	[firstName release];
	[lastName release];
	
	[super dealloc];
}

@end
