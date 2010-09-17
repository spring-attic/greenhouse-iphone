//
//  WebImageView.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/12/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "WebImageView.h"


@implementation WebImageView

@synthesize imageUrl;

- (id)initWithURL:(NSURL *)url
{
	if ((self = [super initWithImage:nil]))
	{
		self.imageUrl = url;
		[self startImageDownload];
	}
	
	return self;
}

- (void)startImageDownload
{
	DLog(@"%@", imageUrl);
	
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:imageUrl];
    _urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[request release];
	
	if (_urlConnection)
	{
		_receivedData = [[NSMutableData data] retain];
	}
}

- (void)cancelImageDownload
{
    [_urlConnection cancel];
    [_urlConnection release];
    [_receivedData release];
}


#pragma mark -
#pragma mark NSURLConnectionDelegate methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [_receivedData release];
    [connection release];
	
	DLog(@"Connection failed! Error - %@ %@",
		 [error localizedDescription],
		 [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [connection release];
	
	DLog(@"Succeeded! Received %d bytes of data", [_receivedData length]);
		
    UIImage *downloadedImage = [[UIImage alloc] initWithData:_receivedData];
	[_receivedData release];
	self.image = downloadedImage;
	[downloadedImage release];    
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc
{
	[super dealloc];
}

@end
