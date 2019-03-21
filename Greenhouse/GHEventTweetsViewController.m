//
//  Copyright 2010-2012 the original author or authors.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//
//  GHEventTweetsViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 9/12/10.
//

#import "GHEventTweetsViewController.h"
#import "GHEventTweetViewController.h"
#import "GHEventTweetDetailsViewController.h"
#import "GHEventController.h"
#import "Event.h"
#import "GHTwitterController.h"
#import "GHTweetDetailsViewController.h"
#import "GHDataRefreshController.h"

@interface GHEventTweetsViewController ()

@property (nonatomic, strong) Event *event;

@end

@implementation GHEventTweetsViewController

@synthesize event;

- (void)showTwitterForm
{
    self.tweetViewController.tweetText = event.hashtag;
    [super showTwitterForm];
}

- (void)fetchTweetsWithPage:(NSUInteger)page
{
	[[GHTwitterController sharedInstance] sendRequestForTweetsWithEventId:event.eventId
                                                                     page:page
                                                                 delegate:self];
}


#pragma mark -
#pragma mark GHPullRefreshTableViewController

- (NSString *)lastRefreshKey
{
    return @"EventTweets";
}

- (NSDate *)lastRefreshDate
{
    return [[GHDataRefreshController sharedInstance] fetchLastRefreshDateWithEventId:self.event.eventId
                                                                          descriptor:self.lastRefreshKey];
}

- (void)setLastRefreshDate:(NSDate *)date
{
    [[GHDataRefreshController sharedInstance] setLastRefreshDateWithEventId:self.event.eventId
                                                                 descriptor:self.lastRefreshKey];
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    self.tweetViewController = [[GHEventTweetViewController alloc] initWithNibName:@"GHTweetViewController" bundle:nil];
	self.tweetDetailsViewController = [[GHEventTweetDetailsViewController alloc] initWithNibName:@"GHTweetDetailsViewController" bundle:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.event = [[GHEventController sharedInstance] fetchSelectedEvent];
    if (self.event == nil)
    {
        DLog(@"selected event not available");
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    
    [super viewWillAppear:animated];
    DLog(@"");
    
    if (self.event)
    {
        self.tweets = [[GHTwitterController sharedInstance] fetchTweetsWithEventId:event.eventId];
        if (self.tweets && self.tweets.count > 0)
        {
            [self reloadTableDataWithTweets:self.tweets];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    DLog(@"");
    
    if (self.tweets == nil || self.tweets.count == 0 || self.lastRefreshExpired)
    {
        [self fetchTweetsWithPage:1];
    }
}

- (void)viewDidUnload
{
	[super viewDidUnload];
    DLog(@"");
	
	self.event = nil;
}

@end
