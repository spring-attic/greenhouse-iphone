//
//  UpdatesMainViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/1/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "UpdatesMainViewController.h"
#import "OAuthManager.h"
#import "Update.h"


@interface UpdatesMainViewController()

@property (nonatomic, retain) NSMutableArray *arrayUpdates;

@end


@implementation UpdatesMainViewController

@synthesize arrayUpdates;
@synthesize barButtonRefresh;
@synthesize tableViewUpdates;

- (IBAction)actionRefresh:(id)sender
{
	[self refreshData];
}

- (void)refreshData
{
	[self fetchJSONDataWithURL:[NSURL URLWithString:UPDATES_URL]];
}

- (void)fetchRequest:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	if (ticket.didSucceed)
	{
		[arrayUpdates removeAllObjects];
		
		NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSArray *array = [responseBody JSONValue];
		[responseBody release];
		
		DLog(@"%@", array);
		
		for (NSDictionary *d in array) 
		{
			Update *update = [[Update alloc] initWithDictionary:d];
			[arrayUpdates addObject:update];
			[update release];
		}
		
		[tableViewUpdates reloadData];
	}
}


#pragma mark -
#pragma mark UITableViewDelegate methods


#pragma mark -
#pragma mark UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdent = @"updateCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
	
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdent] autorelease];
	}
	
	Update *update = (Update *)[arrayUpdates objectAtIndex:indexPath.row];
	
	[cell.textLabel setText:update.text];
	[cell.detailTextLabel setText:[update.timestamp description]];
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (arrayUpdates)
	{
		return [arrayUpdates count];
	}
	
	return 0;
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];

	self.arrayUpdates = [[NSMutableArray alloc] init];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[self refreshData];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{	
	[super viewDidUnload];
	
	self.arrayUpdates = nil;
	self.barButtonRefresh = nil;
	self.tableViewUpdates = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[arrayUpdates release];
	[barButtonRefresh release];
	[tableViewUpdates release];
	
    [super dealloc];
}


@end
