//
//  Event.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/8/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "Event.h"


@implementation Event

@synthesize title;
@synthesize description;

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
			self.title = [dictionary stringForKey:@"title"];
			self.description = [dictionary stringForKey:@"description"];
		}
	}
	
	return self;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc
{
	[title release];
	[description release];
	
	[super dealloc];
}

@end
