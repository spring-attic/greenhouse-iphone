//
//  OA2SignInRequest.h
//  Greenhouse
//
//  Created by Roy Clarkson on 8/27/12.
//  Copyright (c) 2012 VMware, Inc. All rights reserved.
//

#import "GHURLPostRequest.h"
#import "OA2SignInRequestParameters.h"

@interface OA2SignInRequest : GHURLPostRequest

- (id)initWithURL:(NSURL *)URL username:(NSString *)username password:(NSString *)password;
- (id)initWithURL:(NSURL *)URL signInParameters:(OA2SignInRequestParameters *)signInParameters;

@end
