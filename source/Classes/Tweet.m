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
			self.tweetId = [dictionary integerForKey:@"id"];
			self.text = [dictionary stringForKey:@"text"];
			self.createdAt = [dictionary dateWithMillisecondsSince1970ForKey:@"createdAt"];
			self.fromUser = [dictionary stringForKey:@"fromUser"];
			self.profileImageUrl = [dictionary stringForKey:@"profileImageUrl"];
			self.userId = [dictionary integerForKey:@"userId"];
			self.languageCode = [dictionary stringForKey:@"languageCode"];
			self.source = [dictionary stringForKey:@"source"];
		}
		else 
		{
			self.text = [NSString string];
			self.createdAt = [NSDate distantPast];
			self.fromUser = [NSString string];
			self.profileImageUrl = [NSString string];
			self.languageCode = [NSString string];
			self.source = [NSString string];
		}
	}
	
	return self;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc
{
	[text release];
	[createdAt release];
	[fromUser release];
	[profileImageUrl release];
	[languageCode release];
	[source release];
	
	[super dealloc];
}

@end
