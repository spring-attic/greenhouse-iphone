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
//  GHEventController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/31/10.
//

#import "GHEventController.h"
#import "GHEvent.h"


@implementation GHEventController

@synthesize delegate;


#pragma mark -
#pragma mark Instance methods

- (void)fetchEvents
{
	NSURL *url = [[NSURL alloc] initWithString:EVENTS_URL];
    NSMutableURLRequest *request = [[GHAuthorizedRequest alloc] initWithURL:url];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	DLog(@"%@", request);
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
         if (statusCode == 200 && data.length > 0 && error == nil)
         {
             [self fetchEventsDidFinishWithData:data];
         }
         else if (error)
         {
             [self fetchEventsDidFailWithError:error];
         }
         else if (statusCode != 200)
         {
             [self requestDidNotSucceedWithDefaultMessage:@"A problem occurred while retrieving the event data." response:response];
         }
     }];
}

- (void)fetchEventsDidFinishWithData:(NSData *)data
{
	NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	DLog(@"%@", responseBody);
	
	NSMutableArray *events = [[NSMutableArray alloc] init];
    NSArray *jsonArray = [responseBody yajl_JSON];
    DLog(@"%@", jsonArray);
    
    [jsonArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [events addObject:[[GHEvent alloc] initWithDictionary:obj]];
    }];
	
	if ([delegate respondsToSelector:@selector(fetchEventsDidFinishWithResults:)])
	{
		[delegate fetchEventsDidFinishWithResults:events];
	}
}

- (void)fetchEventsDidFailWithError:(NSError *)error
{
	[self requestDidFailWithError:error];
	
	if ([delegate respondsToSelector:@selector(fetchEventsDidFailWithError:)])
	{
		[delegate fetchEventsDidFailWithError:error];
	}
}

@end
