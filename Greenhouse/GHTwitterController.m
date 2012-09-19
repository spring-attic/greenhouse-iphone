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

#define TWITTER_PAGE_SIZE   20

#import <CoreLocation/CoreLocation.h>
#import "GHTwitterController.h"
#import "GHEventController.h"
#import "GHEventSessionController.h"
#import "GHURLRequestParameters.h"
#import "GHCoreDataManager.h"
#import "Tweet.h"
#import "Event.h"
#import "EventSession.h"

@interface GHTwitterController ()

- (void)storeTweetsWithEventId:(NSNumber *)eventId json:(NSArray *)tweets;
- (void)storeTweetsWithEventId:(NSNumber *)eventId sessionNumber:(NSNumber *)sessionNumber json:(NSArray *)tweets;
- (void)postUpdate:(NSString *)update URL:(NSURL *)url delegate:(id<GHTwitterControllerDelegate>)delegate;
- (void)postRetweetWithTweetId:(NSString *)tweetId URL:(NSURL *)url delegate:(id<GHTwitterControllerDelegate>)delegate;

@end

@implementation GHTwitterController


#pragma mark -
#pragma mark Static methods

// Use this class method to obtain the shared instance of the class.
+ (id)sharedInstance
{
    static id _sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

+ (NSInteger)pageSize
{
    return TWITTER_PAGE_SIZE;
}


#pragma mark -
#pragma mark Instance methods

- (Tweet *)fetchTweetWithId:(NSString *)tweetId
{
    DLog(@"tweetId: %@", tweetId);
    NSManagedObjectContext *context = [[GHCoreDataManager sharedInstance] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tweet" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tweetId == %@", tweetId];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    Tweet *tweet = nil;
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (!error && fetchedObjects && fetchedObjects.count > 0)
    {
        tweet = [fetchedObjects objectAtIndex:0];
    }
    return tweet;
}

- (NSArray *)fetchTweetsWithEventId:(NSNumber *)eventId
{
    DLog(@"eventId: %@", eventId);
    NSManagedObjectContext *context = [[GHCoreDataManager sharedInstance] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tweet" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"event.eventId == %@", eventId];
    NSSortDescriptor *sortById = [[NSSortDescriptor alloc] initWithKey:@"tweetId" ascending:NO];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortById]];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    DLog(@"fetched: %u", fetchedObjects.count);
    return fetchedObjects;
}

- (NSArray *)fetchTweetsWithEventId:(NSNumber *)eventId sessionNumber:(NSNumber *)sessionNumber
{
    DLog(@"eventId: %@, sessionNumber: %@", eventId, sessionNumber);
    NSManagedObjectContext *context = [[GHCoreDataManager sharedInstance] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tweet" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(event.eventId == %@) AND (session.number == %@)", eventId, sessionNumber];
    NSSortDescriptor *sortById = [[NSSortDescriptor alloc] initWithKey:@"tweetId" ascending:NO];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortById]];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    DLog(@"fetched: %u", fetchedObjects.count);
    return fetchedObjects;
}

- (Tweet *)fetchSelectedTweet
{
    DLog(@"");
    NSString *tweetId = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedTweetId"];
    return [self fetchTweetWithId:tweetId];
}

- (void)setSelectedTweet:(Tweet *)tweet
{
    DLog(@"");
    [[NSUserDefaults standardUserDefaults] setObject:tweet.tweetId forKey:@"selectedTweetId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)sendRequestForTweetsWithEventId:(NSNumber *)eventId page:(NSUInteger)page delegate:(id<GHTwitterControllerDelegate>)delegate
{
    NSURL *url = [GHConnectionSettings urlWithFormat:@"/events/%@/tweets?page=%d&pageSize=%d", eventId, page, TWITTER_PAGE_SIZE];
    NSMutableURLRequest *request = [[GHAuthorizedRequest alloc] initWithURL:url];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	DLog(@"%@", request);
	
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
         if (statusCode == 200 && data.length > 0 && error == nil)
         {
             DLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
             NSError *error;
             NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
             if (!error)
             {
                 DLog(@"%@", dictionary);
                 NSArray *jsonArray = [dictionary objectForKey:@"tweets"];
                 NSInteger resultCount = [jsonArray count];
                 dispatch_sync(dispatch_get_main_queue(), ^{
                     [self storeTweetsWithEventId:eventId json:jsonArray];
                     NSArray *tweets = [self fetchTweetsWithEventId:eventId];
                     [delegate fetchTweetsDidFinishWithResults:tweets resultCount:resultCount];
                 });
             }
             else
             {
                 dispatch_sync(dispatch_get_main_queue(), ^{
                     [delegate fetchTweetsDidFailWithError:error];
                 });
             }
             
         }
         else if (error)
         {
             [self requestDidFailWithError:error];
             dispatch_sync(dispatch_get_main_queue(), ^{
                 [delegate fetchTweetsDidFailWithError:error];
             });
         }
         else if (statusCode != 200)
         {
             [self requestDidNotSucceedWithDefaultMessage:@"A problem occurred while retrieving the list of tweets." response:response];
             dispatch_sync(dispatch_get_main_queue(), ^{
                 [delegate fetchTweetsDidFailWithError:nil];
             });
         }
     }];
}

- (void)sendRequestForTweetsWithEventId:(NSNumber *)eventId sessionNumber:(NSNumber *)sessionNumber page:(NSUInteger)page delegate:(id<GHTwitterControllerDelegate>)delegate
{
    NSURL *url = [GHConnectionSettings urlWithFormat:@"/events/%@/sessions/%@/tweets?page=%d&pageSize=%d", eventId, sessionNumber, page, TWITTER_PAGE_SIZE];
    NSMutableURLRequest *request = [[GHAuthorizedRequest alloc] initWithURL:url];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	DLog(@"%@", request);
	
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
         if (statusCode == 200 && data.length > 0 && error == nil)
         {
             DLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
             NSError *error;
             NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
             if (!error)
             {
                 DLog(@"%@", dictionary);
                 NSArray *jsonArray = [dictionary objectForKey:@"tweets"];
                 NSInteger resultCount = [jsonArray count];
                 dispatch_sync(dispatch_get_main_queue(), ^{
                     [self storeTweetsWithEventId:eventId sessionNumber:sessionNumber json:jsonArray];
                     NSArray *tweets = [self fetchTweetsWithEventId:eventId sessionNumber:sessionNumber];
                     [delegate fetchTweetsDidFinishWithResults:tweets resultCount:resultCount];
                 });
             }
             else
             {
                 dispatch_sync(dispatch_get_main_queue(), ^{
                     [delegate fetchTweetsDidFailWithError:error];
                 });
             }
         }
         else if (error)
         {
             [self requestDidFailWithError:error];
             dispatch_sync(dispatch_get_main_queue(), ^{
                 [delegate fetchTweetsDidFailWithError:error];
             });
         }
         else if (statusCode != 200)
         {
             [self requestDidNotSucceedWithDefaultMessage:@"A problem occurred while retrieving the list of tweets." response:response];
             dispatch_sync(dispatch_get_main_queue(), ^{
                 [delegate fetchTweetsDidFailWithError:nil];
             });
         }
     }];
}


- (void)storeTweetsWithEventId:(NSNumber *)eventId json:(NSArray *)tweets
{
    DLog(@"");
    Event *event = [[GHEventController sharedInstance] fetchEventWithId:eventId];
    [tweets enumerateObjectsUsingBlock:^(NSDictionary *tweetDict, NSUInteger idx, BOOL *stop) {
        
        NSString *tweetId = [tweetDict stringForKey:@"id"];
        Tweet *tweet = [self fetchTweetWithId:tweetId];
        
        // only store a tweet if it doesn't already exist
        if (tweet == nil)
        {
            tweet = [self tweetWithJson:tweetDict];
            [event addTweetsObject:tweet];
        }
    }];
    
    NSManagedObjectContext *context = [[GHCoreDataManager sharedInstance] managedObjectContext];
    NSError *error;
    [context save:&error];
    if (error)
    {
        DLog(@"%@", [error localizedDescription]);
    }
}

- (void)storeTweetsWithEventId:(NSNumber *)eventId sessionNumber:(NSNumber *)sessionNumber json:(NSArray *)tweets
{
    DLog(@"");
    Event *event = [[GHEventController sharedInstance] fetchEventWithId:eventId];
    EventSession *session = [[GHEventSessionController sharedInstance] fetchSessionWithNumber:sessionNumber];
    [tweets enumerateObjectsUsingBlock:^(NSDictionary *tweetDict, NSUInteger idx, BOOL *stop) {
        NSString *tweetId = [tweetDict stringForKey:@"id"];
        Tweet *tweet = [self fetchTweetWithId:tweetId];
        
        // only store a tweet if it doesn't already exist
        if (tweet == nil)
        {
            tweet = [self tweetWithJson:tweetDict];
        }
        if (tweet.event == nil)
        {
            [event addTweetsObject:tweet];
        }
        [session addTweetsObject:tweet];
    }];
    
    NSManagedObjectContext *context = [[GHCoreDataManager sharedInstance] managedObjectContext];
    NSError *error;
    [context save:&error];
    if (error)
    {
        DLog(@"%@", [error localizedDescription]);
    }
}

- (Tweet *)tweetWithJson:(NSDictionary *)json
{
    NSManagedObjectContext *context = [[GHCoreDataManager sharedInstance] managedObjectContext];
    Tweet *tweet = [NSEntityDescription
                    insertNewObjectForEntityForName:@"Tweet"
                    inManagedObjectContext:context];
    tweet.tweetId = [json stringForKey:@"id"];
    tweet.text = [[json stringForKey:@"text"] stringByXMLDecoding];
    tweet.createdAt = [json dateWithMillisecondsSince1970ForKey:@"createdAt"];
    tweet.fromUser = [json stringByReplacingPercentEscapesForKey:@"fromUser" usingEncoding:NSUTF8StringEncoding];
    tweet.profileImageUrl = [[json stringForKey:@"profileImageUrl"] stringByURLDecoding];
    tweet.userId = [json stringForKey:@"userId"];
    tweet.languageCode = [json stringForKey:@"languageCode"];
    tweet.source = [[json stringForKey:@"source"] stringByURLDecoding];
    return tweet;
}

- (void)postUpdate:(NSString *)update eventId:(NSNumber *)eventId delegate:(id<GHTwitterControllerDelegate>)delegate
{
    NSURL *url = [GHConnectionSettings urlWithFormat:@"/events/%@/tweets", eventId];
    [self postUpdate:update URL:url delegate:delegate];
}

- (void)postUpdate:(NSString *)update eventId:(NSNumber *)eventId sessionNumber:(NSNumber *)sessionNumber delegate:(id<GHTwitterControllerDelegate>)delegate
{
    NSURL *url = [GHConnectionSettings urlWithFormat:@"/events/%@/sessions/%@/tweets", eventId, sessionNumber];
    [self postUpdate:update URL:url delegate:delegate];
}

- (void)postUpdate:(NSString *)update URL:(NSURL *)url delegate:(id<GHTwitterControllerDelegate>)delegate
{
    NSMutableURLRequest *request = [[GHAuthorizedRequest alloc] initWithURL:url];
	NSString *status = [update stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	DLog(@"tweet length: %i", status.length);

//    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
//                            status, @"status",
//                            location.coordinate.latitude, @"latitude",
//                            location.coordinate.longitude, @"longitude",
//                            nil];
//    GHURLRequestParameters *postParams = [[GHURLRequestParameters alloc] initWithDictionary:params];
	
    CLLocation *location = [[CLLocation alloc] init];
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
	
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];         
         NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
         if (statusCode == 200 && error == nil)
         {
             dispatch_sync(dispatch_get_main_queue(), ^{
                 [delegate postUpdateDidFinish];
             });
         }
         else if (error)
         {
             [self requestDidFailWithError:error];
             dispatch_sync(dispatch_get_main_queue(), ^{
                 [delegate postUpdateDidFailWithError:error];
             });
         }
         else if (statusCode != 200)
         {
             [self processStatusCode:statusCode];
             dispatch_sync(dispatch_get_main_queue(), ^{
                 [delegate postUpdateDidFailWithError:error];
             });
         }
     }];
}

- (void)postRetweetWithTweetId:(NSString *)tweetId eventId:(NSNumber *)eventId delegate:(id<GHTwitterControllerDelegate>)delegate
{
    NSURL *url = [GHConnectionSettings urlWithFormat:@"/events/%@/retweet", eventId];
    [self postRetweetWithTweetId:tweetId URL:url delegate:delegate];
}

- (void)postRetweetWithTweetId:(NSString *)tweetId eventId:(NSNumber *)eventId sessionNumber:(NSNumber *)sessionNumber delegate:(id<GHTwitterControllerDelegate>)delegate
{
    NSURL *url = [GHConnectionSettings urlWithFormat:@"/events/%@/sessions/%@/retweet", eventId, sessionNumber];
    [self postRetweetWithTweetId:tweetId URL:url delegate:delegate];
}

- (void)postRetweetWithTweetId:(NSString *)tweetId URL:(NSURL *)url delegate:(id<GHTwitterControllerDelegate>)delegate
{
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

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];         
         NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
         if (statusCode == 200 && error == nil)
         {
             dispatch_sync(dispatch_get_main_queue(), ^{
                 [delegate postRetweetDidFinish];
             });
         }
         else if (error)
         {
             [self requestDidFailWithError:error];
             dispatch_sync(dispatch_get_main_queue(), ^{
                 [delegate postRetweetDidFailWithError:error];
             });
         }
         else if (statusCode != 200)
         {
             [self processStatusCode:statusCode];
             dispatch_sync(dispatch_get_main_queue(), ^{
                 [delegate postRetweetDidFailWithError:error];
             });
         }
     }];
}


#pragma mark -
#pragma mark Private Instance methods

- (void)processStatusCode:(NSInteger)statusCode
{
    NSString *msg = nil;
    switch (statusCode)
    {
        case 412:
            msg = @"Your account is not connected to Twitter. Please sign in to Greenhouse to connect.";
            break;
        case 403:
        default:
            msg = @"A problem occurred while posting to Twitter. Please verify your account is connected to Twitter.";
            break;
    }
    dispatch_sync(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:msg
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    });
}


@end
