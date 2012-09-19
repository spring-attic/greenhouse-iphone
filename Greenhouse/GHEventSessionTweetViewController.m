//
//  Copyright 2012 the original author or authors.
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
//  GHEventSessionTweetViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 9/14/12.
//

#import "GHEventSessionTweetViewController.h"
#import "Event.h"
#import "EventSession.h"
#import "GHEventController.h"
#import "GHEventSessionController.h"
#import "GHTwitterController.h"

@interface GHEventSessionTweetViewController ()

@property (nonatomic, strong) Event *event;
@property (nonatomic, strong) EventSession *session;

@end

@implementation GHEventSessionTweetViewController

@synthesize event;
@synthesize session;


#pragma mark -
#pragma mark Public Instance methods

- (void)sendTweet:(NSString *)text
{
    [[GHTwitterController sharedInstance] postUpdate:text
                                             eventId:event.eventId
                                       sessionNumber:session.number
                                            delegate:self];
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    DLog(@"");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DLog(@"");
    
    self.event = [[GHEventController sharedInstance] fetchSelectedEvent];
    self.session = [[GHEventSessionController sharedInstance] fetchSelectedSession];
    if (self.event == nil)
    {
        DLog(@"selected event or session not available");
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}

- (void)viewWillUnload
{
    [super viewWillUnload];
    DLog(@"");
    
    self.event = nil;
    self.session = nil;
}

@end
