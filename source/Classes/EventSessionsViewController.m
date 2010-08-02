    //
//  EventSessionsViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/2/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "EventSessionsViewController.h"


@implementation EventSessionsViewController

@synthesize arraySessions;
@synthesize event;
@synthesize sessionDetailsViewController;
@synthesize tableViewSessions;


- (EventSession *)eventSessionForIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}


#pragma mark -
#pragma mark DataViewDelegate

- (void)refreshView
{
	
}

- (void)fetchData
{
	
}


#pragma mark -
#pragma mark UITableViewDelegate methods


#pragma mark -
#pragma mark UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 0;
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.sessionDetailsViewController = [[EventSessionDetailsViewController alloc] initWithNibName:nil bundle:nil];	
	self.arraySessions = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.arraySessions = nil;
	self.event = nil;
	self.sessionDetailsViewController = nil;
	self.tableViewSessions = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[arraySessions release];
	[event release];
	[sessionDetailsViewController release];
	[tableViewSessions release];
	
    [super dealloc];
}


@end
