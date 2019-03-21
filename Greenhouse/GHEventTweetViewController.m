//
//  Copyright 2012 the original author or authors.
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
//  GHEventTweetViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 9/13/12.
//

#import "GHEventTweetViewController.h"
#import "Event.h"
#import "GHEventController.h"
#import "GHTwitterController.h"

@interface GHEventTweetViewController ()

@property (nonatomic, strong) Event *event;

@end

@implementation GHEventTweetViewController

@synthesize event;

- (void)sendTweet:(NSString *)text
{
    [[GHTwitterController sharedInstance] postUpdate:text eventId:event.eventId delegate:self];
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
    if (self.event == nil)
    {
        DLog(@"selected event not available");
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}

- (void)viewWillUnload
{
    [super viewWillUnload];
    DLog(@"");
    
    self.event = nil;
}

@end
