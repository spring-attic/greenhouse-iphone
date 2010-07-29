//
//  OAuthViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/16/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DataViewDelegate

- (void)refreshView;
- (void)fetchData;

@end


@interface OAuthViewController : UIViewController <UIAlertViewDelegate>
{

}

@property (nonatomic, assign) BOOL fetchingData;

- (void)fetchJSONDataWithURL:(NSURL *)url;
- (void)fetchRequest:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
- (void)fetchRequest:(OAServiceTicket *)ticket didFailWithError:(NSError *)error;

@end
