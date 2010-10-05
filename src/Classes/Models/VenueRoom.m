//
//  VenueRoom.m
//  Greenhouse
//
//  Created by Roy Clarkson on 10/5/10.
//  Copyright 2010 VMware. All rights reserved.
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
