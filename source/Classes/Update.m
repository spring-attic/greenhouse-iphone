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

- (id)initWithDictionary:(NSDictionary *)dictionary
{
	if ((self = [super init]))
	{
		if (dictionary)
		{
			self.text = [dictionary stringByReplacingPercentEscapesForKey:@"text" usingEncoding:NSUTF8StringEncoding];
			self.timestamp = [dictionary localDateWithMillisecondsSince1970ForKey:@"timestamp"];
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
