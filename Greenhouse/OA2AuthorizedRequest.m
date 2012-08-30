//
//  OA2AuthorizedRequest.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/27/12.
//  Copyright (c) 2012 VMware, Inc. All rights reserved.
//

#import "OA2AuthorizedRequest.h"

@implementation OA2AuthorizedRequest

- (id)initWithURL:(NSURL *)URL accessToken:(NSString *)accessToken
{
    if (self = [super initWithURL:URL])
    {
        [self setAuthorization:[self bearerTokenWithAccessToken:accessToken]];
    }
    return self;
}

- (NSString *)bearerTokenWithAccessToken:(NSString *)accessToken
{
    return [[NSString alloc] initWithFormat:@"Bearer %@", accessToken];
}

@end
