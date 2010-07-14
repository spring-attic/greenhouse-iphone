    //
//  EventDetailsViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/13/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "EventDetailsViewController.h"


@interface EventDetailsViewController()

@property (nonatomic, retain) NSArray *arrayMenuItems;

@end


@implementation EventDetailsViewController

@synthesize arrayMenuItems;
@synthesize event;
@synthesize labelTitle;
@synthesize labelDescription;
@synthesize labelStartTime;
@synthesize labelEndTime;
@synthesize labelLocation;
@synthesize labelHashtag;
@synthesize tableViewMenu;


#pragma mark -
#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.row) 
	{
		case 0:
			// show sessions
			break;
		case 1:
			// show tweets
			break;
		default:
			break;
	}
}


#pragma mark -
#pragma mark UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdent = @"menuCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
	
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	NSString *s = (NSString *)[arrayMenuItems objectAtIndex:indexPath.row];
	
	[cell.textLabel setText:s];
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (arrayMenuItems)
	{
		return [arrayMenuItems count];
	}
	
	return 0;
}



#pragma mark -
#pragma mark UIViewController methods

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.title = @"Event Details";
	
	self.arrayMenuItems = [[NSArray alloc] initWithObjects:@"Sessions", @"Tweets", nil];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	//	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	//	labelStartTime.text = [dateFormatter stringFromDate:event.startTime];
	//	labelEndTime.text = [dateFormatter stringFromDate:event.endTime];
	//	[dateFormatter release];	
	
	labelTitle.text = event.title;
	labelDescription.text = event.description;
	labelStartTime.text = [event.startTime description];
	labelEndTime.text = [event.endTime description];
	labelLocation.text = event.location;
	labelHashtag.text = event.hashtag;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.arrayMenuItems = nil;
	self.event = nil;
	self.labelTitle = nil;
	self.labelDescription = nil;
	self.labelStartTime = nil;
	self.labelEndTime = nil;
	self.labelLocation = nil;
	self.labelHashtag = nil;
	self.tableViewMenu = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[arrayMenuItems release];
	[event release];
	[labelTitle release];
	[labelDescription release];
	[labelStartTime release];
	[labelEndTime release];
	[labelLocation release];
	[labelHashtag release];
	[tableViewMenu release];
	
    [super dealloc];
}


@end
