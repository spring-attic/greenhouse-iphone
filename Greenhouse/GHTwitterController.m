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
//  GHTwitterController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/27/10.
//

#import "GHTwitterController.h"
#import "GHTweet.h"
#import "GHURLRequestParameters.h"

@implementation GHTwitterController

@synthesize delegate;


#pragma mark -
#pragma mark Instance methods

- (void)fetchTweetsWithURL:(NSURL *)url page:(NSUInteger)page;
{
	NSString *urlString = [[NSString alloc] initWithFormat:@"%@?page=%d&pageSize=%d", [url absoluteString], page, TWITTER_PAGE_SIZE];
    NSMutableURLRequest *request = [[GHAuthorizedRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	DLog(@"%@", request);
	
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
         if (statusCode == 200 && data.length > 0 && error == nil)
         {
             [self fetchTweetsDidFinishWithData:data];
         }
         else if (error)
         {
             [self fetchTweetsDidFailWithError:error];
         }
         else if (statusCode != 200)
         {
             [self requestDidNotSucceedWithDefaultMessage:@"A problem occurred while retrieving the list of tweets." response:response];
         }
     }];
}

- (void)fetchTweetsDidFinishWithData:(NSData *)data
{
	DLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
	
	NSMutableArray *tweets = [[NSMutableArray alloc] init];
	BOOL lastPage = NO;
    
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (!error)
    {
        DLog(@"%@", dictionary);
        lastPage = [dictionary boolForKey:@"lastPage"];
        NSArray *jsonArray = (NSArray *)[dictionary objectForKey:@"tweets"];        
        [jsonArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [tweets addObject:[[GHTweet alloc] initWithDictionary:obj]];
        }];
    }

	if ([delegate respondsToSelector:@selector(fetchTweetsDidFinishWithResults:lastPage:)])
	{
		[delegate fetchTweetsDidFinishWithResults:tweets lastPage:lastPage];
	}
}

- (void)fetchTweetsDidFailWithError:(NSError *)error
{
	[self requestDidFailWithError:error];
	
	if ([delegate respondsToSelector:@selector(fetchTweetsDidFailWithError:)])
	{
		[delegate fetchTweetsDidFailWithError:error];
	}
}

- (void)postUpdate:(NSString *)update withURL:(NSURL *)url
{
	CLLocation *location = [[CLLocation alloc] init];
	[self postUpdate:update withURL:url location:location];
}

- (void)postUpdate:(NSString *)update withURL:(NSURL *)url location:(CLLocation *)location
{
	self.activityAlertView = [[GHActivityAlertView alloc] initWithActivityMessage:@"Posting tweet..."];
	[_activityAlertView startAnimating];

    NSMutableURLRequest *request = [[GHAuthorizedRequest alloc] initWithURL:url];
	NSString *status = [update stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	DLog(@"tweet length: %i", status.length);

//    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
//                            status, @"status",
//                            location.coordinate.latitude, @"latitude",
//                            location.coordinate.longitude, @"longitude",
//                            nil];
//    GHURLRequestParameters *postParams = [[GHURLRequestParameters alloc] initWithDictionary:params];
	
	NSString *postParams = [[NSString alloc] initWithFormat:@"status=%@&latitude=%f&longitude=%f",
                            [status stringByURLEncoding],
							location.coordinate.latitude,
                            location.coordinate.longitude];
	DLog(@"%@", postParams);
	NSData *postData = [postParams dataUsingEncoding:NSUTF8StringEncoding];
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];

	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:postData];
	
	DLog(@"%@", request);
	
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         [_activityAlertView stopAnimating];
         self.activityAlertView = nil;
         
         NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
         if (statusCode == 200 && data.length > 0 && error == nil)
         {
             [self postUpdateDidFinishWithData:data];
         }
         else if (error)
         {
             [self postUpdateDidFailWithError:error];
         }
         else if (statusCode != 200)
         {
             NSString *msg = nil;
             switch (statusCode)
             {
                 case 412:
                     msg = @"Your account is not connected to Twitter. Please sign in to greenhouse.springsource.org to connect.";
                     break;
                 case 403:
                 default:
                     msg = @"A problem occurred while posting to Twitter.";
                     break;
             }
             
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                 message:msg
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
             [alertView show];
         }
     }];
}

- (void)postUpdateDidFinishWithData:(NSData *)data
{
    DLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    if ([delegate respondsToSelector:@selector(postUpdateDidFinish)])
    {
        [delegate postUpdateDidFinish];
    }
}

- (void)postUpdateDidFailWithError:(NSError *)error
{
	[self requestDidFailWithError:error];
	
	if ([delegate respondsToSelector:@selector(postUpdateDidFailWithError:)])
	{
		[delegate postUpdateDidFailWithError:error];
	}
}

- (void)postRetweet:(NSString *)tweetId withURL:(NSURL *)url;
{
	self.activityAlertView = [[GHActivityAlertView alloc] initWithActivityMessage:@"Posting tweet..."];
	[_activityAlertView startAnimating];
	
    NSMutableURLRequest *request = [[GHAuthorizedRequest alloc] initWithURL:url];
	NSString *postParams =[[NSString alloc] initWithFormat:@"tweetId=%@", tweetId];
	NSString *escapedPostParams = [postParams stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	DLog(@"%@", escapedPostParams);
	
	NSData *postData = [escapedPostParams dataUsingEncoding:NSUTF8StringEncoding];	
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:postData];
	DLog(@"%@ %@", request, [request allHTTPHeaderFields]);

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         [_activityAlertView stopAnimating];
         self.activityAlertView = nil;
         
         NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
         if (statusCode == 200 && data.length > 0 && error == nil)
         {
             [self postRetweetDidFinishWithData:data];
         }
         else if (error)
         {
             [self postRetweetDidFailWithError:error];
         }
         else if (statusCode != 200)
         {
             NSString *msg = nil;
             switch (statusCode)
             {
                 case 412:
                     msg = @"Your account is not connected to Twitter. Please sign in to greenhouse.springsource.org to connect.";
                     break;
                 case 403:
                 default:
                     msg = @"A problem occurred while posting to Twitter. Please verify your account is connected to Twitter.";
                     break;
             }
             
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                 message:msg
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
             [alertView show];
         }
     }];
}

- (void)postRetweetDidFinishWithData:(NSData *)data
{
	DLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
	
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Retweet successful!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
    
    if ([delegate respondsToSelector:@selector(postRetweetDidFinish)])
    {
        [delegate postRetweetDidFinish];
    }
}

- (void)postRetweetDidFailWithError:(NSError *)error
{
	[self requestDidFailWithError:error];
	
	if ([delegate respondsToSelector:@selector(postRetweetDidFailWithError:)])
	{
		[delegate postRetweetDidFailWithError:error];
	}	
}

@end
