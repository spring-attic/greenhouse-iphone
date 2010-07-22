    //
//  EventDescriptionViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/22/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "EventDescriptionViewController.h"


@implementation EventDescriptionViewController

@synthesize eventDescription;
@synthesize textView;


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
	
	self.title = @"Description";
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	textView.text = eventDescription;
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.eventDescription = nil;
	self.textView = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[eventDescription release];
	[textView release];
	
    [super dealloc];
}


@end
