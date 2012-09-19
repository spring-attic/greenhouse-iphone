//
//  Copyright 2012 the original author or authors.
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
//  GHConnectionSettings.m
//  Greenhouse
//
//  Created by Roy Clarkson on 9/18/12.
//

#pragma mark -
#pragma mark LOCALHOST

#if LOCALHOST

#define OAUTH_CLIENT_ID                     @"a08318eb478a1ee31f69a55276f3af64"
#define OAUTH_CLIENT_SECRET                 @"80e7f8f7ba724aae9103f297e5fb9bdf"
#define GREENHOUSE_URL						@"http://192.168.0.1:8080/greenhouse"

#pragma mark -
#pragma mark QA

#elif QA

#define OAUTH_CLIENT_ID                     @""
#define OAUTH_CLIENT_SECRET                 @""
#define GREENHOUSE_URL						@"https://greenhouse.springsource.org"

#pragma mark -
#pragma mark PRODUCTION

#elif PRODUCTION

#define OAUTH_CLIENT_ID                     @""
#define OAUTH_CLIENT_SECRET                 @""
#define GREENHOUSE_URL						@"https://greenhouse.springsource.org"

#endif

#pragma mark -

#import "GHConnectionSettings.h"

@implementation GHConnectionSettings


#pragma mark -
#pragma mark Static methods

+ (NSString *)clientId
{
    return OAUTH_CLIENT_ID;
}

+ (NSString *)clientSecret
{
    return OAUTH_CLIENT_SECRET;
}

+ (NSString *)url
{
    return GREENHOUSE_URL;
}

+ (NSURL *)urlWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2)
{
    va_list arguments;
    va_start(arguments, format);
    NSString* s = [[NSString alloc] initWithFormat:format arguments:arguments];
    va_end(arguments);
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", GREENHOUSE_URL, s]];
}

@end
