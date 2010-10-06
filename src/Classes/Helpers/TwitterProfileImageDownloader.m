//
//  TwitterProfileImageDownloader.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/4/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "TwitterProfileImageDownloader.h"
#import "Tweet.h"

#define kImageHeight 48


@implementation TwitterProfileImageDownloader

@synthesize tweet;
@synthesize indexPathInTableView;
@synthesize delegate;

- (void)startDownload
{
	if (!tweet)
	{
		return;
	}
	
	NSURL *url = [[NSURL alloc] initWithString:tweet.profileImageUrl];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
	[url release];
	
    _urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[request release];
	
	if (_urlConnection)
	{
		_receivedData = [[NSMutableData data] retain];
	}
}

- (void)cancelDownload
{
	if (_urlConnection)
	{
		[_urlConnection cancel];
		[_urlConnection release];
		_urlConnection = nil;
	}
	
	if (_receivedData)
	{
		[_receivedData release];
		_receivedData = nil;
	}
}


#pragma mark -
#pragma mark NSURLConnectionDelegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [_receivedData release];
	_receivedData = nil;
	
    [_urlConnection release];
	_urlConnection = nil;
	
	DLog(@"Connection failed! Error - %@ %@",
		 [error localizedDescription],
		 [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [_urlConnection release];
	_urlConnection = nil;
	
	DLog(@"Succeeded! Received %d bytes of data", [_receivedData length]);
	
    UIImage *image = [[UIImage alloc] initWithData:_receivedData];

    [_receivedData release];
	_receivedData = nil;
    
    if (image.size.width != kImageHeight && image.size.height != kImageHeight)
	{
        CGSize itemSize = CGSizeMake(kImageHeight, kImageHeight);
		UIGraphicsBeginImageContext(itemSize);
		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
		[image drawInRect:imageRect];
		self.tweet.profileImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
    }
    else
    {
        self.tweet.profileImage = image;
    }
	
	[image release];
	
    [delegate profileImageDidLoad:self.indexPathInTableView];
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc
{
	[self cancelDownload];
	
    [tweet release];
    [indexPathInTableView release];
    
    [super dealloc];
}

@end

