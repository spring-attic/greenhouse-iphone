//
//  OA2AuthorizedRequest.h
//  Greenhouse
//
//  Created by Roy Clarkson on 8/27/12.
//  Copyright (c) 2012 VMware, Inc. All rights reserved.
//

#import "GHURLRequest.h"

@interface OA2AuthorizedRequest : GHURLRequest

- (id)initWithURL:(NSURL *)URL accessToken:(NSString *)accessToken;
- (NSString *)bearerTokenWithAccessToken:(NSString *)accessToken;

@end
