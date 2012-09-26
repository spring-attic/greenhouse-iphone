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
//  GHEventSessionTweetsViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 9/13/10.
//

#import "GHEventSessionTweetsViewController.h"
#import "GHEventSessionTweetViewController.h"
#import "GHEventSessionTweetDetailsViewController.h"
#import "GHEventController.h"
#import "GHEventSessionController.h"
#import "GHTwitterController.h"
#import "GHDataRefreshController.h"

@interface GHEventSessionTweetsViewController()

@property (nonatomic, strong) EventSession *currentSession;

@end

@implementation GHEventSessionTweetsViewController

@synthesize event;
@synthesize session;

- (void)showTwitterForm
{
    self.tweetViewController.tweetText = [[NSString alloc] initWithFormat:@"%@ %@", event.hashtag, session.hashtag];
    [super showTwitterForm];
}

- (void)fetchTweetsWithPage:(NSUInteger)page
{
	[[GHTwitterController sharedInstance] sendRequestForTweetsWithEventId:event.eventId
                                                            sessionNumber:session.number
                                                                     page:page
                                                                 delegate:self];
}


#pragma mark -
#pragma mark GHPullRefreshTableViewController

- (NSString *)lastRefreshKey
{
    return @"EventSessionTweets";
}

- (NSDate *)lastRefreshDate
{
    return [[GHDataRefreshController sharedInstance] fetchLastRefreshDateWithEventId:self.event.eventId
                                                                       sessionNumber:self.session.number
                                                                          descriptor:self.lastRefreshKey];
}

- (void)setLastRefreshDate:(NSDate *)date
{
    [[GHDataRefreshController sharedInstance] setLastRefreshDateWithEventId:self.event.eventId
                                                              sessionNumber:self.session.number
                                                                 descriptor:self.lastRefreshKey];
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad
{
	[super viewDidLoad];
    DLog(@"");
    
    self.tweetViewController = [[GHEventSessionTweetViewController alloc] initWithNibName:@"GHTweetViewController" bundle:nil];
	self.tweetDetailsViewController = [[GHEventSessionTweetDetailsViewController alloc] initWithNibName:@"GHTweetDetailsViewController" bundle:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.event = [[GHEventController sharedInstance] fetchSelectedEvent];
    self.session = [[GHEventSessionController sharedInstance] fetchSelectedSession];
    if (self.event == nil || self.session == nil)
    {
        DLog(@"selected event or session not available");
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    
    [super viewWillAppear:animated];
    DLog(@"");
    
    if (self.event && self.session)
    {
        self.tweets = [[GHTwitterController sharedInstance] fetchTweetsWithEventId:event.eventId sessionNumber:session.number];
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
	self.session = nil;
}

@end
