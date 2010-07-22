//
//  SessionLeader.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/21/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "SessionLeader.h"


@implementation SessionLeader

@synthesize firstName;
@synthesize lastName;

- (id)initWithDictionary:(NSDictionary *)dictionary
{
	if ((self = [super init]))
	{
		self.firstName = [dictionary stringForKey:@"firstName"];
		self.lastName = [dictionary stringForKey:@"lastName"];
	}
	
	return self;
}


#pragma mark -
#pragma mark NSObject methods

- (NSString *)description
{
	if (firstName && lastName)
	{
		return [NSString stringWithFormat:@"%@ %@", firstName, lastName];
	}
	
	return @"";
}

- (void)dealloc
{
	[firstName release];
	[lastName release];
	
	[super dealloc];
}

@end
