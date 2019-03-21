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
//  GHEventSessionsConferenceFavoritesViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/2/10.
//

#import "GHEventSessionsConferenceFavoritesViewController.h"
#import "Event.h"
#import "GHEventSessionController.h"

@implementation GHEventSessionsConferenceFavoritesViewController


#pragma mark -
#pragma mark EventSessionControllerDelegate methods

- (void)fetchConferenceFavoriteSessionsDidFinishWithResults:(NSArray *)sessions
{
	self.sessions = sessions;
	[self.tableView reloadData];
	[self dataSourceDidFinishLoadingNewData];
}

- (void)fetchConferenceFavoriteSessionsDidFailWithError:(NSError *)error
{
	[self dataSourceDidFinishLoadingNewData];
}


#pragma mark -
#pragma mark DataViewController methods

//- (void)reloadTableViewDataSource
//{
//	[eventSessionController fetchConferenceFavoriteSessionsByEventId:self.event.eventId delegate self];
//}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
	self.lastRefreshKey = @"EventSessionFavoritesViewController_LastRefresh";
    [super viewDidLoad];
    DLog(@"");
    
	self.title = @"Conference Favorites";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DLog(@"");
    
	[[GHEventSessionController sharedInstance] fetchConferenceFavoriteSessionsByEventId:self.event.eventId delegate:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    DLog(@"");
}

@end
