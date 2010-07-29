    //
//  EventSessionDescriptionViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/26/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "EventSessionDescriptionViewController.h"


@implementation EventSessionDescriptionViewController

@synthesize session;
@synthesize textViewDescription;


#pragma mark -
#pragma mark DataViewDelegate

- (void)refreshView
{
	textViewDescription.text = session.description;
}

- (void)fetchData
{
}

#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.title = @"Description";
	
	textViewDescription.editable = NO;
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.session = nil;
	self.textViewDescription = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[session release];
	[textViewDescription release];
	
    [super dealloc];
}


@end
