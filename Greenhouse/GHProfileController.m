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
//  GHProfileController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 9/7/10.
//

#import "GHProfileController.h"
#import "GHProfile.h"

@implementation GHProfileController

@synthesize delegate;


#pragma mark -
#pragma mark Instance methods

- (void)fetchProfile
{
	NSURL *url = [[NSURL alloc] initWithString:MEMBER_PROFILE_URL];
    NSMutableURLRequest *request = [[GHAuthorizedRequest alloc] initWithURL:url];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	DLog(@"%@", request);
	
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (data.length > 0 && error == nil)
         {
             [self fetchProfileDidFinishWithData:data];
         }
         else
         {
             [self fetchProfileDidFailWithError:error];
         }
     }];
}

- (void)fetchProfileDidFinishWithData:(NSData *)data
{
	NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	DLog(@"%@", responseBody);
	
	NSDictionary *dictionary = [responseBody yajl_JSON];
	DLog(@"%@", dictionary);
		
	GHProfile *profile = [GHProfile profileWithDictionary:dictionary];
	
	if ([delegate respondsToSelector:@selector(fetchProfileDidFinishWithResults:)])
	{
		[delegate fetchProfileDidFinishWithResults:profile];
	}
}

- (void)fetchProfileDidFailWithError:(NSError *)error
{
	[self requestDidFailWithError:error];
	
	if ([delegate respondsToSelector:@selector(fetchProfileDidFailWithError:)])
	{
		[delegate fetchProfileDidFailWithError:error];
	}
}

@end
