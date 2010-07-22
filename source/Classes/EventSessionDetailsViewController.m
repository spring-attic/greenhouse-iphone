    //
//  EventSessionDetailsViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/21/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "EventSessionDetailsViewController.h"


@implementation EventSessionDetailsViewController

@synthesize session;
@synthesize labelTitle;
@synthesize labelLeader;
@synthesize labelTime;
@synthesize textViewSummary;


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.title = @"Session Details";
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if (session)
	{
		labelTitle.text = session.title;
		labelLeader.text = session.leaderDisplay;

		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"h:mma"];
		NSString *formattedStartTime = [dateFormatter stringFromDate:session.startTime];
		NSString *formattedEndTime = [dateFormatter stringFromDate:session.endTime];
		[dateFormatter release];
		
		NSString *formattedTime = [[NSString alloc] initWithFormat:@"%@ - %@", formattedStartTime, formattedEndTime];
		labelTime.text = formattedTime;
		[formattedTime release];
		
		textViewSummary.text = session.summary;
	}
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.session = nil;
	self.labelTitle = nil;
	self.labelLeader = nil;
	self.labelTime = nil;
	self.textViewSummary = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[session release];
	[labelTitle release];
	[labelLeader release];
	[labelTime release];
	[textViewSummary release];
	
    [super dealloc];
}


@end
