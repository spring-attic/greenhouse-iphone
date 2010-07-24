    //
//  NewTweetViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/23/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "NewTweetViewController.h"


@implementation NewTweetViewController

@synthesize barButtonCancel;
@synthesize barButtonSend;
@synthesize textViewDelegate;

- (IBAction)actionCancel:(id)sender
{
}

- (IBAction)actionSend:(id)sender
{
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
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.barButtonCancel = nil;
	self.barButtonSend = nil;
	self.textViewDelegate = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[barButtonCancel release];
	[barButtonSend release];
	[textViewDelegate release];
	
    [super dealloc];
}


@end
