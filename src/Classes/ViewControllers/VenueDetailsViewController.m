    //
//  VenueDetailsViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 10/4/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "VenueDetailsViewController.h"
#import "Venue.h"


@implementation VenueDetailsViewController

@synthesize venue;
@synthesize labelName;
@synthesize labelLocationHint;
@synthesize labelAddress;
@synthesize buttonDirections;

- (IBAction)actionGetDirections:(id)sender
{
	NSString *encodedAddress = [venue.postalAddress URLEncodedString];
	NSString *urlString = [[NSString alloc] initWithFormat:@"http://maps.google.com/maps?q=%@", encodedAddress];
	NSURL *url = [NSURL URLWithString:urlString];
	[urlString release];
	
	[[UIApplication sharedApplication] openURL:url];
}


#pragma mark -
#pragma mark DataViewController methods

- (void)refreshView
{
	if (venue)
	{
		labelName.text = venue.name;
		labelLocationHint.text = venue.locationHint;
		labelAddress.text = venue.postalAddress;
	}
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.title = @"Venue";
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.venue = nil;
	self.labelName = nil;
	self.labelLocationHint = nil;
	self.labelAddress = nil;
	self.buttonDirections = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[venue release];
	[labelName release];
	[labelLocationHint release];
	[labelAddress release];
	[buttonDirections release];
	
    [super dealloc];
}


@end
