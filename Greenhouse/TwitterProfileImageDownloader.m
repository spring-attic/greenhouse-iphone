//
//  Copyright 2010-2012 the original author or authors.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//
//  TwitterProfileImageDownloader.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/4/10.
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
	
    _urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if (_urlConnection)
	{
		_receivedData = [NSMutableData data];
	}
}

- (void)cancelDownload
{
	if (_urlConnection)
	{
		[_urlConnection cancel];
		_urlConnection = nil;
	}
	
	if (_receivedData)
	{
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
	_receivedData = nil;
	_urlConnection = nil;
	
	DLog(@"Connection failed! Error - %@ %@",
		 [error localizedDescription],
		 [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	_urlConnection = nil;
	
	DLog(@"Succeeded! Received %d bytes of data", [_receivedData length]);
	
    UIImage *image = [[UIImage alloc] initWithData:_receivedData];
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
	
    [delegate profileImageDidLoad:self.indexPathInTableView];
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc
{
	[self cancelDownload];
}

@end

