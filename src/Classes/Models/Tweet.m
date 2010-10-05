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


#pragma mark -
#pragma mark WebDataModel methods

- (id)initWithDictionary:(NSDictionary *)dictionary
{
	if ((self = [super init]))
	{
		if (dictionary)
		{
			self.tweetId = [dictionary stringForKey:@"id"];
			self.text = [[dictionary stringForKey:@"text"] stringBySimpleXmlDecoding];
			self.createdAt = [dictionary dateWithMillisecondsSince1970ForKey:@"createdAt"];
			self.fromUser = [dictionary stringByReplacingPercentEscapesForKey:@"fromUser" usingEncoding:NSUTF8StringEncoding];
			self.profileImageUrl = [[dictionary stringForKey:@"profileImageUrl"] URLDecodedString];
			self.userId = [dictionary stringForKey:@"userId"];
			self.languageCode = [dictionary stringForKey:@"languageCode"];
			self.source = [[dictionary stringForKey:@"source"] URLDecodedString];
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
	[profileImage release];
	
	[super dealloc];
}

@end
