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

- (id)initWithDictionary:(NSDictionary *)dictionary
{
	if ((self = [super init]))
	{
		if (dictionary)
		{
			self.firstName = [dictionary stringForKey:@"firstName"];
			self.lastName = [dictionary stringForKey:@"lastName"];
		}
	}
	
	return self;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc
{
	[firstName release];
	[lastName release];
	
	[super dealloc];
}

@end
