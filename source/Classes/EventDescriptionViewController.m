    //
//  EventDescriptionViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/22/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "EventDescriptionViewController.h"


@implementation EventDescriptionViewController

@synthesize event;
@synthesize textView;


#pragma mark -
#pragma mark DataViewController methods

- (void)refreshView
{
	textView.text = event.description;
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.title = @"Description";

	textView.editable = NO;
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.event = nil;
	self.textView = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[event release];
	[textView release];
	
    [super dealloc];
}


@end
