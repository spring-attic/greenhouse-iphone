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
@synthesize startTime;
@synthesize endTime;
@synthesize location;
@synthesize description;
@synthesize name;
@synthesize hashtag;
@synthesize groupName;
@synthesize groupProfileKey;

- (id)initWithDictionary:(NSDictionary *)dictionary
{
	if ((self = [super init]))
	{
		if (dictionary)
		{
			self.eventId = [dictionary stringForKey:@"id"];
			self.title = [dictionary stringByReplacingPercentEscapesForKey:@"title" usingEncoding:NSUTF8StringEncoding];
			self.startTime = [dictionary dateWithMillisecondsSince1970ForKey:@"startTime"];
			self.endTime = [dictionary dateWithMillisecondsSince1970ForKey:@"endTime"];
			self.location = [dictionary stringByReplacingPercentEscapesForKey:@"location" usingEncoding:NSUTF8StringEncoding];
			self.description = [[dictionary stringForKey:@"description"] stringBySimpleXmlDecoding];
			self.name = [dictionary stringByReplacingPercentEscapesForKey:@"name" usingEncoding:NSUTF8StringEncoding];
			self.hashtag = [dictionary stringByReplacingPercentEscapesForKey:@"hashtag" usingEncoding:NSUTF8StringEncoding];
			self.groupName = [dictionary stringByReplacingPercentEscapesForKey:@"groupName" usingEncoding:NSUTF8StringEncoding];
			self.groupProfileKey = [dictionary stringForKey:@"groupProfileKey"];
		}
	}
	
	return self;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc
{
	[eventId release];
	[title release];
	[startTime release];
	[endTime release];
	[location release];
	[description release];
	[name release];
	[hashtag release];
	[groupName release];
	[groupProfileKey release];
	
	[super dealloc];
}

@end
