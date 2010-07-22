//
//  EventSession.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/21/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "EventSession.h"
#import "SessionLeader.h"


@implementation EventSession

@synthesize title;
@synthesize summary;
@synthesize startTime;
@synthesize endTime;
@synthesize leaders;
@dynamic leaderCount;
@dynamic leaderDisplay;

- (id)initWithDictionary:(NSDictionary *)dictionary
{
	if ((self = [super init]))
	{
		if (dictionary)
		{
			self.title = [dictionary stringForKey:@"title"];
			self.summary = [dictionary stringForKey:@"summary"];
			self.startTime = [dictionary dateWithMillisecondsSince1970ForKey:@"startTime"];
			self.endTime = [dictionary dateWithMillisecondsSince1970ForKey:@"endTime"];
			
			self.leaders = [[NSMutableArray alloc] init];
			NSArray *array = [dictionary objectForKey:@"leaders"];
			for (NSDictionary *d in array) 
			{
				SessionLeader *leader = [[SessionLeader alloc] initWithDictionary:d];
				[leaders addObject:leader];
				[leader release];
			}
		}
	}
	
	return self;
}

- (NSInteger)leaderCount
{
	if (leaders)
	{
		return [leaders count];
	}
	
	return 0;
}

- (NSString *)leaderDisplay
{
	if (leaders)
	{
		return [self.leaders componentsJoinedByString:@", "];
	}
	
	return @"";
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc
{
	[title release];
	[summary release];
	[startTime release];
	[endTime release];
	[leaders release];
	
	[super dealloc];
}

@end
