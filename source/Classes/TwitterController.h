//
//  TwitterController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 8/27/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthController.h"
#import <CoreLocation/CoreLocation.h>
#import "TwitterControllerDelegate.h"


@interface TwitterController : OAuthController 
{ 
	id<TwitterControllerDelegate> _delegate;
}

@property (nonatomic, assign) id<TwitterControllerDelegate> delegate;

- (void)fetchTweetsWithURL:(NSURL *)url;
- (void)fetchTweets:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
- (void)fetchTweets:(OAServiceTicket *)ticket didFailWithError:(NSError *)error;
- (void)postUpdate:(NSString *)update withURL:(NSURL *)url;
- (void)postUpdate:(NSString *)update withURL:(NSURL *)url location:(CLLocation *)location;
- (void)postUpdate:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
- (void)postUpdate:(OAServiceTicket *)ticket didFailWithError:(NSError *)error;
- (void)postRetweet:(NSString *)tweetId withURL:(NSURL *)url;
- (void)postRetweet:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
- (void)postRetweet:(OAServiceTicket *)ticket didFailWithError:(NSError *)error;

@end
