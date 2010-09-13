//
//  EventController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 8/31/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthControllerBase.h"


@protocol EventControllerDelegate

@optional

- (void)fetchEventsDidFinishWithResults:(NSArray *)events;

@end


@interface EventController : OAuthControllerBase { }

@property (nonatomic, assign) id<EventControllerDelegate> delegate;

+ (EventController *)eventController;

- (void)fetchEvents;
- (void)fetchEvents:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
- (void)fetchEvents:(OAServiceTicket *)ticket didFailWithError:(NSError *)error;

@end
