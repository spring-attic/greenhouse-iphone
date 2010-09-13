//
//  TwitterController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 8/27/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthControllerBase.h"
#import <CoreLocation/CoreLocation.h>


@protocol TwitterControllerDelegate

@optional

- (void)fetchTweetsDidFinishWithResults:(NSArray *)tweets;
- (void)postUpdateDidFinish;
- (void)postUpdateDidFailWithError:(NSError *)error;

@end


@interface TwitterController : OAuthControllerBase { }

@property (nonatomic, assign) id<TwitterControllerDelegate> delegate;

+ (TwitterController *)twitterController;

- (void)fetchTweetsWithURL:(NSURL *)url;
- (void)fetchTweets:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
- (void)fetchTweets:(OAServiceTicket *)ticket didFailWithError:(NSError *)error;
//- (void)postEventUpdate:(NSString *)update;
//- (void)postEventUpdate:(NSString *)update withLocation:(CLLocation *)location;
//- (void)postEventSessionUpdate:(NSString *)update;
//- (void)postEventSessionUpdate:(NSString *)update withLocation:(CLLocation *)location;
- (void)postUpdate:(NSString *)update withURL:(NSURL *)url;
- (void)postUpdate:(NSString *)update withURL:(NSURL *)url location:(CLLocation *)location;
- (void)postUpdate:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
- (void)postUpdate:(OAServiceTicket *)ticket didFailWithError:(NSError *)error;

@end
