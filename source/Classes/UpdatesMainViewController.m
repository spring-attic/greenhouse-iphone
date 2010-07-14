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
	[[OAuthManager sharedInstance] fetchUpdatesWithDelegate:self 
										  didFinishSelector:@selector(showUpdates:) 
											didFailSelector:@selector(showErrorMessage:)];	
}

- (void)showUpdates:(NSString *)details
{
	[arrayUpdates removeAllObjects];
	
	NSArray *array = [details JSONValue];
	DLog(@"%@", array);
	
	for (NSDictionary *d in array) 
	{
		Update *update = [[Update alloc] initWithDictionary:d];
		[arrayUpdates addObject:update];
		[update release];
	}
	
	[tableViewUpdates reloadData];
}

- (void)showErrorMessage:(NSError *)error
{
	NSString *message = nil;
	
	if ([error code] == NSURLErrorUserCancelledAuthentication)
	{
		message = @"You are not authorized to view the content from greenhouse.com. Please sign out and reauthorize the app.";
	}
	else 
	{
		message = @"An error occurred while connecting to the server.";
	}
	
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
													message:message 
												   delegate:nil 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
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
