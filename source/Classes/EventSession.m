//
//  EventSession.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/21/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "EventSession.h"
#import "Person.h"


@implementation EventSession

@synthesize number;
@synthesize title;
@synthesize startTime;
@synthesize endTime;
@synthesize description;
@synthesize leaders;
@synthesize hashtag;
@synthesize isFavorite;
@dynamic leaderCount;
@dynamic leaderDisplay;

- (id)initWithDictionary:(NSDictionary *)dictionary
{
	if ((self = [super init]))
	{
		if (dictionary)
		{
			self.number = [dictionary integerForKey:@"number"];
			self.title = [dictionary stringByReplacingPercentEscapesForKey:@"title" usingEncoding:NSUTF8StringEncoding];
			self.startTime = [dictionary localDateWithMillisecondsSince1970ForKey:@"startTime"];
			self.endTime = [dictionary localDateWithMillisecondsSince1970ForKey:@"endTime"];
			self.description = [dictionary stringByReplacingPercentEscapesForKey:@"description" usingEncoding:NSUTF8StringEncoding];
			self.hashtag = [dictionary stringByReplacingPercentEscapesForKey:@"hashtag" usingEncoding:NSUTF8StringEncoding];
			self.isFavorite = NO;

			self.leaders = [[NSMutableArray alloc] init];
			NSArray *array = [dictionary objectForKey:@"leaders"];
			for (NSDictionary *d in array) 
			{
				Person *leader = [[Person alloc] initWithDictionary:d];
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
	[description release];
	[startTime release];
	[endTime release];
	[leaders release];
	[hashtag release];
	
	[super dealloc];
}

@end
