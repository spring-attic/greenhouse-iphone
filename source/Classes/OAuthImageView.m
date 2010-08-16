//
//  OAuthImageView.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/16/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "OAuthImageView.h"
#import "OAuthManager.h"


@implementation OAuthImageView

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
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:imageUrl 
																   consumer:[OAuthManager sharedInstance].consumer
																	  token:[OAuthManager sharedInstance].accessToken
																	  realm:OAUTH_REALM
														  signatureProvider:nil]; // use the default method, HMAC-SHA1
	
//	[request setHTTPMethod:@"GET"];
	
	DLog(@"%@", request);
	
	OADataFetcher *fetcher = [[OADataFetcher alloc] init];
	
	[fetcher fetchDataWithRequest:request
						 delegate:self
				didFinishSelector:@selector(fetchRequest:didFinishWithData:)
				  didFailSelector:@selector(fetchRequest:didFailWithError:)];
	
	[request release];
}

- (void)cancelImageDownload
{
	// may not be able to do this with the oauth request
}

- (void)fetchRequest:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{	
	NSHTTPURLResponse *response = (NSHTTPURLResponse *)ticket.response;
	DLog(@"%@", [response allHeaderFields]);
	DLog(@"statusCode: %i", [response statusCode]);
	
	if ([response statusCode] == 302)
	{
		NSString *urlString = [[response allHeaderFields] objectForKey:@"Location"];
		self.imageUrl = [[NSURL alloc] initWithString:urlString];
		[self startImageDownload];
	}
	
	else if (ticket.didSucceed)
	{
		UIImage *downloadedImage = [[UIImage alloc] initWithData:data];
		
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
		
		[downloadedImage release];
	}	
}

- (void)fetchRequest:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	DLog(@"%@", [error localizedDescription]);
	
	NSString *message = nil;
	
	if ([error code] == NSURLErrorUserCancelledAuthentication)
	{
		message = @"You are not authorized to view the requested resource.";
	}
	else 
	{
		message = @"An error occurred while connecting to the server.";
	}	
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
													message:message 
												   delegate:nil 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];	
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc
{
	[imageUrl release];
	
	[super dealloc];
}

@end
