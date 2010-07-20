//
//  OAuthViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/16/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OAuthViewController : UIViewController 
{

}

- (void)fetchJSONDataWithURL:(NSURL *)url;
- (void)fetchRequest:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
- (void)fetchRequest:(OAServiceTicket *)ticket didFailWithError:(NSError *)error;

@end
