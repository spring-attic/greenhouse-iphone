//
//  WebImageView.h
//  Greenhouse
//
//  Created by Roy Clarkson on 8/12/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WebImageView : UIImageView 
{
	NSURLConnection *_urlConnection;
	NSMutableData *_receivedData;
}

@property (nonatomic, retain) NSURL *imageUrl;

- (id)initWithURL:(NSURL *)url;
- (void)startImageDownload;
- (void)cancelImageDownload;

@end
