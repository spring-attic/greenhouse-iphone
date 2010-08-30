//
//  OAuthControllerBase.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/27/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "OAuthControllerBase.h"


@implementation OAuthControllerBase

@synthesize dataFetcher;


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc
{
	[dataFetcher release];
	
	[super dealloc];
}

@end
