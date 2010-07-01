//
//  Update.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/1/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "Update.h"


@implementation Update

@synthesize text;
@synthesize timestamp;

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
			self.text = [dictionary stringForKey:@"text"];
			self.timestamp = [dictionary stringForKey:@"timestamp"];
		}
	}
	
	return self;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc
{
	[text release];
	[timestamp release];
	
	[super dealloc];
}

@end
