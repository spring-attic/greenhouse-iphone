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
//  EventSessionsConferenceFavoritesViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/2/10.
//

#import "EventSessionsConferenceFavoritesViewController.h"


@interface EventSessionsConferenceFavoritesViewController()

@property (nonatomic, strong) EventSessionController *eventSessionController;

- (void)completeFetchConferenceFavoriteSessions:(NSArray *)sessions;

@end


@implementation EventSessionsConferenceFavoritesViewController

@synthesize eventSessionController;

- (void)completeFetchConferenceFavoriteSessions:(NSArray *)sessions
{
	self.eventSessionController = nil;
	self.arraySessions = sessions;
	[self.tableView reloadData];
	[self dataSourceDidFinishLoadingNewData];
}

#pragma mark -
#pragma mark EventSessionControllerDelegate methods

- (void)fetchConferenceFavoriteSessionsDidFinishWithResults:(NSArray *)sessions
{
	[self completeFetchConferenceFavoriteSessions:sessions];
}

- (void)fetchConferenceFavoriteSessionsDidFailWithError:(NSError *)error
{
	NSArray *array = [[NSArray alloc] init];
	[self completeFetchConferenceFavoriteSessions:array];
}


#pragma mark -
#pragma mark DataViewController methods

- (void)reloadTableViewDataSource
{
	self.eventSessionController = [[EventSessionController alloc] init];
	eventSessionController.delegate = self;	
	[eventSessionController fetchConferenceFavoriteSessionsByEventId:self.event.eventId];
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
	self.lastRefreshKey = @"EventSessionFavoritesViewController_LastRefresh";
	
    [super viewDidLoad];
	
	self.title = @"Conference Favorites";
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.eventSessionController = nil;
}

@end
