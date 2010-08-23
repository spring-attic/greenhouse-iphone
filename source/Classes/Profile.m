//
//  Profile.m
//  Greenhouse
//
//  Created by Roy Clarkson on 6/11/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "Profile.h"


@implementation Profile

@synthesize accountId;
@synthesize displayName;
@dynamic imageUrl;
@dynamic largeImageUrl;
@dynamic smallImageUrl;


- (NSURL *)imageUrl
{
	return [NSURL URLWithString:[NSString stringWithFormat:MEMBER_PROFILE_PICTURE_URL, accountId]];
}

- (NSURL *)smallImageUrl
{
	return [NSURL URLWithString:[NSString stringWithFormat:MEMBER_PROFILE_SMALL_PICTURE_URL, accountId]];
}

- (NSURL *)largeImageUrl
{
	return [NSURL URLWithString:[NSString stringWithFormat:MEMBER_PROFILE_LARGE_PICTURE_URL, accountId]];
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
	if ((self = [super init]))
	{
		if (dictionary)
		{
			self.accountId = [dictionary integerForKey:@"accountId"];
			self.displayName = [dictionary stringByReplacingPercentEscapesForKey:@"displayName" usingEncoding:NSUTF8StringEncoding];			
		}
	}
	
	return self;
}


#pragma mark -
#pragma mark NSObject methods

- (NSString *)description
{
	return self.displayName;
}

- (void)dealloc
{
	[displayName release];
	
	[super dealloc];
}

@end
