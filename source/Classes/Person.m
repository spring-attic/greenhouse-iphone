//
//  Person.m
//  Greenhouse
//
//  Created by Roy Clarkson on 6/11/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "Person.h"


@implementation Person

@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize emailAddress = _emailAddress;


- (id)init
{
	return [self initWithDictionary:nil];
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
	if ((self = [super init]))
	{
		if (dictionary)
		{
			self.firstName = [dictionary stringForKey:@"firstName"];
			self.lastName = [dictionary stringForKey:@"lastName"];
			self.emailAddress = [dictionary stringForKey:@"emailAddress"];
		}
	}
	
	return self;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc
{
	[_firstName release];
	[_lastName release];
	[_emailAddress release];
	
	[super dealloc];
}

@end
