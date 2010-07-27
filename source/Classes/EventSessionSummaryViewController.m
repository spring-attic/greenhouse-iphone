    //
//  EventSessionSummaryViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/26/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "EventSessionSummaryViewController.h"


@implementation EventSessionSummaryViewController

@synthesize session;
@synthesize textViewSummary;

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.title = @"Summary";
	
	textViewSummary.editable = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
	textViewSummary.text = session.description;
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.session = nil;
	self.textViewSummary = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[session release];
	[textViewSummary release];
	
    [super dealloc];
}


@end
