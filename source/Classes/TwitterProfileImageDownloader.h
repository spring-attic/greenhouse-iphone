//
//  TwitterProfileImageDownloader.h
//  Greenhouse
//
//  Created by Roy Clarkson on 8/4/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import <Foundation/Foundation.h>


@class Tweet;


@protocol TwitterProfileImageDownloaderDelegate 

- (void)profileImageDidLoad:(NSIndexPath *)indexPath;

@end


@interface TwitterProfileImageDownloader : NSObject 
{
	NSURLConnection *_urlConnection;
	NSMutableData *_receivedData;
}

@property (nonatomic, retain) Tweet *tweet;
@property (nonatomic, retain) NSIndexPath *indexPathInTableView;
@property (nonatomic, assign) id <TwitterProfileImageDownloaderDelegate> delegate;

- (void)startDownload;
- (void)cancelDownload;

@end
