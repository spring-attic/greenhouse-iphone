//
//  TweetProfileImageDownloader.h
//  Greenhouse
//
//  Created by Roy Clarkson on 8/4/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import <Foundation/Foundation.h>


@class Tweet;
@class RootViewController;


@protocol TweetProfileImageDownloaderDelegate;


@interface TweetProfileImageDownloader : NSObject
{

}

@property (nonatomic, retain) Tweet *tweet;
@property (nonatomic, retain) NSIndexPath *indexPathInTableView;
@property (nonatomic, assign) id <TweetProfileImageDownloaderDelegate> delegate;
@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, retain) NSURLConnection *urlConnection;

- (void)startDownload;
- (void)cancelDownload;

@end


@protocol TweetProfileImageDownloaderDelegate 

- (void)profileImageDidLoad:(NSIndexPath *)indexPath;

@end