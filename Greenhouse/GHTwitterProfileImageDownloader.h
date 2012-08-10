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
//  GHTwitterProfileImageDownloader.h
//  Greenhouse
//
//  Created by Roy Clarkson on 8/4/10.
//

#import <Foundation/Foundation.h>


@class GHTweet;


@protocol GHTwitterProfileImageDownloaderDelegate 

- (void)profileImageDidLoad:(NSIndexPath *)indexPath;

@end


@interface GHTwitterProfileImageDownloader : NSObject 
{
	NSURLConnection *_urlConnection;
	NSMutableData *_receivedData;
}

@property (nonatomic, strong) GHTweet *tweet;
@property (nonatomic, strong) NSIndexPath *indexPathInTableView;
@property (nonatomic, unsafe_unretained) id <GHTwitterProfileImageDownloaderDelegate> delegate;

- (void)startDownload;
- (void)cancelDownload;

@end
