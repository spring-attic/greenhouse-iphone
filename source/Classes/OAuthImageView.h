//
//  OAuthImageView.h
//  Greenhouse
//
//  Created by Roy Clarkson on 8/16/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OAuthImageView : UIImageView 
{

}

@property (nonatomic, retain) NSURL *imageUrl;

- (id)initWithURL:(NSURL *)url;
- (void)startImageDownload;
- (void)cancelImageDownload;
- (void)fetchRequest:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
- (void)fetchRequest:(OAServiceTicket *)ticket didFailWithError:(NSError *)error;

@end
