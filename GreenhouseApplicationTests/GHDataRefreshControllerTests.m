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
//  GHDataRefreshControllerTests.m
//  Greenhouse
//
//  Created by Roy Clarkson on 9/25/12.
//

#import "GHDataRefreshControllerTests.h"
#import "GHDataRefreshController.h"

@implementation GHDataRefreshControllerTests


#pragma mark -
#pragma mark SenTestCase methods

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}


#pragma mark -
#pragma mark Test methods

- (void)testWithEventId
{
    NSDate *now = [NSDate date];
    [[GHDataRefreshController sharedInstance] setLastRefreshDateWithEventId:[NSNumber numberWithInteger:14]
                                                                 descriptor:@"testEventRefresh"];
    NSDate *lastRefreshDate = [[GHDataRefreshController sharedInstance] fetchLastRefreshDateWithEventId:[NSNumber numberWithInteger:14]
                                                                                  descriptor:@"testEventRefresh"];
    STAssertTrue([now compare:lastRefreshDate] == NSOrderedAscending, @"last refresh date should be slightly newer");
}

@end
