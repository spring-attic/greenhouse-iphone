//
//  OAuthController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 9/16/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OAuthController : NSObject <UIAlertViewDelegate>
{
	OADataFetcher *_dataFetcher;
	id _didFailDelegate;
	SEL _didFailSelector;
	NSError *_error;
}

- (void)request:(OAServiceTicket *)ticket didFailWithError:(NSError *)error didFailDelegate:(id)delegate didFailSelector:(SEL)selector;

@end
