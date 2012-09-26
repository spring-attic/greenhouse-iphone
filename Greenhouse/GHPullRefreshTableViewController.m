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
//  GHPullRefreshTableViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/27/10.
//

#import "GHPullRefreshTableViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "GHDataRefreshController.h"

@interface GHPullRefreshTableViewController()

@property (nonatomic, strong) EGORefreshTableHeaderView *refreshHeaderView;

@end

@implementation GHPullRefreshTableViewController

@synthesize tableView;
@synthesize refreshHeaderView;
@synthesize reloading = _reloading;
@synthesize lastRefreshKey;
@dynamic lastRefreshDate;
@dynamic lastRefreshExpired;

- (NSDate *)lastRefreshDate
{
	NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:self.lastRefreshKey];
    if (date == nil)
    {
        date = [GHDataRefreshController defaultDate];
    }
    DLog(@"%@", date);
    return date;
}

- (void)setLastRefreshDate:(NSDate *)date
{
	[[NSUserDefaults standardUserDefaults] setObject:date forKey:self.lastRefreshKey];
}

- (BOOL)lastRefreshExpired
{
	// if the last refresh was older than the configured time, then expire the data
    NSDate *expireDate = [NSDate dateWithTimeIntervalSinceNow:-[GHUserSettings dataExpiration]];
    DLog(@"last refresh: %@", self.lastRefreshDate);
    DLog(@"expire: %@", expireDate);
	return ([self.lastRefreshDate compare:expireDate] == NSOrderedAscending);
}

- (void)reloadTableViewDataSource
{
	// implement in inherited class
}

- (void)dataSourceDidFinishLoadingNewData
{
	_reloading = NO;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	[self.tableView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[refreshHeaderView setState:EGOOPullRefreshNormal];
	self.lastRefreshDate = [NSDate date];
	[refreshHeaderView setLastUpdateLabel:self.lastRefreshDate];
}


#pragma mark -
#pragma mark UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{		
	if (scrollView.isDragging) 
	{
		if (refreshHeaderView.state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_reloading) 
		{
			[refreshHeaderView setState:EGOOPullRefreshNormal];
		} 
		else if (refreshHeaderView.state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !_reloading) 
		{
			[refreshHeaderView setState:EGOOPullRefreshPulling];
		}
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{	
	if (scrollView.contentOffset.y <= - 65.0f && !_reloading) 
	{
		_reloading = YES;
		[self reloadTableViewDataSource];
		[refreshHeaderView setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		self.tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
	}
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
    DLog(@"");
	
	if (refreshHeaderView == nil) 
	{
		CGRect frame = CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, 320.0f, self.tableView.bounds.size.height);
		self.refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:frame];
		refreshHeaderView.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
		[self.tableView addSubview:refreshHeaderView];
		self.tableView.showsVerticalScrollIndicator = YES;
	}
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DLog(@"");
    
    [refreshHeaderView setLastUpdateLabel:self.lastRefreshDate];
}

- (void)viewDidUnload 
{
	[super viewDidUnload];
    DLog(@"");
	
	self.refreshHeaderView = nil;
    self.tableView = nil;
	self.lastRefreshKey = nil;
}

@end

