//
//  Tweet.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/15/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "Tweet.h"


@implementation Tweet

@synthesize tweetId;
@synthesize text;
@synthesize createdAt;
@synthesize fromUser;
@synthesize profileImageUrl;
@synthesize userId;
@synthesize languageCode;
@synthesize source;
@synthesize profileImage;


- (id)initWithDictionary:(NSDictionary *)dictionary
{
	if ((self = [super init]))
	{
		if (dictionary)
		{
			self.tweetId = [dictionary stringForKey:@"id"];
			self.text = [dictionary stringByReplacingPercentEscapesForKey:@"text" usingEncoding:NSUTF8StringEncoding];
			self.createdAt = [dictionary dateWithMillisecondsSince1970ForKey:@"createdAt"];
			self.fromUser = [dictionary stringByReplacingPercentEscapesForKey:@"fromUser" usingEncoding:NSUTF8StringEncoding];
			self.profileImageUrl = [dictionary stringForKey:@"profileImageUrl"];
			self.userId = [dictionary stringForKey:@"userId"];
			self.languageCode = [dictionary stringForKey:@"languageCode"];
			self.source = [dictionary stringForKey:@"source"];
		}
	}
	
	return self;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc
{
	[tweetId release];
	[text release];
	[createdAt release];
	[fromUser release];
	[profileImageUrl release];
	[userId release];
	[languageCode release];
	[source release];
	
	[super dealloc];
}

@end
