//
//  WebImageView.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/12/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "WebImageView.h"


@interface WebImageView()

@property (nonatomic, retain) NSURLConnection *urlConnection;
@property (nonatomic, retain) NSMutableData *receivedData;

@end


@implementation WebImageView

@synthesize urlConnection;
@synthesize receivedData;
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
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:imageUrl];
    self.urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[request release];
	
	if (urlConnection)
	{
		self.receivedData = [NSMutableData data];
	}
}

- (void)cancelImageDownload
{
    [self.urlConnection cancel];
    self.urlConnection = nil;
    self.receivedData = nil;
}


#pragma mark -
#pragma mark NSURLConnectionDelegate methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.receivedData = nil;
    self.urlConnection = nil;
	
	DLog(@"Connection failed! Error - %@ %@",
		 [error localizedDescription],
		 [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	DLog(@"Succeeded! Received %d bytes of data", [receivedData length]);
	
    UIImage *downloadedImage = [[UIImage alloc] initWithData:self.receivedData];
    
    if (downloadedImage.size.width != self.frame.size.width && 
		downloadedImage.size.height != self.frame.size.height)
	{
        CGSize size = CGSizeMake(self.frame.size.width, self.frame.size.height);
		UIGraphicsBeginImageContext(size);
		CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
		[downloadedImage drawInRect:rect];
		self.image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
    }
    else
    {
        self.image = downloadedImage;
    }
    
    self.receivedData = nil;
    [downloadedImage release];
    
    self.urlConnection = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc
{
	[receivedData release];
	[urlConnection cancel];
	[urlConnection release];
	
	[super dealloc];
}

@end
