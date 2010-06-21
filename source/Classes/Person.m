//
//  Person.m
//  Greenhouse
//
//  Created by Roy Clarkson on 6/11/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "Person.h"


@implementation Person

@synthesize personId = _personId;
@synthesize version = _version;
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
			NSNumber *num = (NSNumber *)[dictionary objectForKey:@"id"];
			self.personId =  [num integerValue];
			
			num = (NSNumber *)[dictionary objectForKey:@"version"];
			self.version = [num integerValue];
			
			self.firstName = (NSString *)[dictionary objectForKey:@"firstName"];
			self.lastName = (NSString *)[dictionary objectForKey:@"lastName"];
			self.emailAddress = (NSString *)[dictionary objectForKey:@"emailAddress"];
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
