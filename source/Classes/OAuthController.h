//
//  OAuthController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 9/16/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActivityAlertView.h"


@interface OAuthController : NSObject <UIAlertViewDelegate>
{
	OAAsynchronousDataFetcher *_dataFetcher;
	ActivityAlertView *_activityAlertiView;
	id _didFailDelegate;
	SEL _didFailSelector;
	NSError *_error;
}

@property (nonatomic, retain) ActivityAlertView *activityAlertiView;

- (void)cancelDataFetcherRequest;
- (void)request:(OAServiceTicket *)ticket didFailWithError:(NSError *)error didFailDelegate:(id)delegate didFailSelector:(SEL)selector;

@end
