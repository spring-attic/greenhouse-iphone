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
@synthesize receivedData;
@synthesize urlConnection;


- (void)startDownload
{
	if (!tweet)
	{
		return;
	}
	
	NSURL *url = [[NSURL alloc] initWithString:tweet.profileImageUrl];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
	[url release];
	
    self.urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[request release];
	
	if (urlConnection)
	{
		self.receivedData = [NSMutableData data];
	}
}

- (void)cancelDownload
{
    [self.urlConnection cancel];
    self.urlConnection= nil;
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
		 [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	DLog(@"Succeeded! Received %d bytes of data", [receivedData length]);
	
    UIImage *image = [[UIImage alloc] initWithData:self.receivedData];
    
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
    
    self.receivedData = nil;
    [image release];
    
    self.urlConnection = nil;
	
    [delegate profileImageDidLoad:self.indexPathInTableView];
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc
{
    [tweet release];
    [indexPathInTableView release];
    [receivedData release];
    [urlConnection cancel];
    [urlConnection release];
    
    [super dealloc];
}

@end

