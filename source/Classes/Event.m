//
//  Event.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/8/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "Event.h"


@implementation Event

@synthesize eventId;
@synthesize title;
@synthesize description;
@synthesize startTime;
@synthesize endTime;
@synthesize location;
@synthesize hashtag;

- (id)initWithDictionary:(NSDictionary *)dictionary
{
	if ((self = [super init]))
	{
		if (dictionary)
		{
			self.title = [dictionary stringForKey:@"title"];
			self.description = [dictionary stringForKey:@"description"];
			self.eventId = [dictionary integerForKey:@"id"];
			self.startTime = [dictionary dateWithMillisecondsSince1970ForKey:@"startTime"];
			self.endTime = [dictionary dateWithMillisecondsSince1970ForKey:@"endTime"];
			self.location = [dictionary stringForKey:@"location"];
			self.hashtag = [dictionary stringForKey:@"hashtag"];
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
