//
//  Copyright 2010-2012 the original author or authors.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//
//  Tweet.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/15/10.
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


- (void)removeCachedProfileImage
{
	self.profileImage = nil;
}


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

@end
