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
//  GHTweetsViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/26/10.
//

#import <UIKit/UIKit.h>
#import "GHTwitterProfileImageDownloader.h"
#import "GHPullRefreshTableViewController.h"
#import "GHTweetViewController.h"

@class GHTweetDetailsViewController;

@interface GHTweetsViewController : GHPullRefreshTableViewController <UITableViewDelegate, UITableViewDataSource, GHTwitterControllerDelegate, GHTwitterProfileImageDownloaderDelegate>

@property (nonatomic, strong) NSArray *tweets;
@property (nonatomic, strong) NSIndexPath *visibleIndexPath;
@property (nonatomic, strong) GHTweetViewController *tweetViewController;
@property (nonatomic, strong) GHTweetDetailsViewController *tweetDetailsViewController;
@property (nonatomic, assign) BOOL isLastPage;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) NSUInteger currentPage;

- (void)showTwitterForm;
- (void)fetchTweetsWithPage:(NSUInteger)page;
- (void)reloadTableDataWithTweets:(NSArray *)tweets;

@end
