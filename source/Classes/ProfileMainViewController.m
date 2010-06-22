    //
//  ProfileMainViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 6/7/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "ProfileMainViewController.h"
#import "OAuthManager.h"
#import "Person.h"


@implementation ProfileMainViewController

@synthesize labelId = _labelId;
@synthesize labelVersion = _labelVersion;
@synthesize labelFirstName = _labelFirstName;
@synthesize labelLastName = _labelLastName;
@synthesize labelEmailAddress = _labelEmailAddress;

- (IBAction)actionSignOut:(id)sender
{
	[[OAuthManager sharedInstance] removeAccessToken];
	[appDelegate showAuthorizeViewController];
}

- (void)showProfileDetails:(NSString *)details
{
	NSDictionary *dictionary = [details JSONValue];
	Person *person = [[Person alloc] initWithDictionary:dictionary];
	
	_labelId.text = [NSString stringWithFormat:@"%i", person.personId];
	_labelVersion.text = [NSString stringWithFormat:@"%i", person.version];
	_labelFirstName.text = person.firstName;
	_labelLastName.text = person.lastName;
	_labelEmailAddress.text = person.emailAddress;
	
	[person release];
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
		
	[[OAuthManager sharedInstance] fetchProfileDetailsWithDelegate:self 
												 didFinishSelector:@selector(showProfileDetails:) 
												   didFailSelector:@selector(actionSignOut:)];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];	
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.labelId = nil;
	self.labelVersion = nil;
	self.labelFirstName = nil;
	self.labelLastName = nil;
	self.labelEmailAddress = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[_labelId release];
	[_labelVersion release];
	[_labelFirstName release];
	[_labelLastName release];
	[_labelEmailAddress release];
	
    [super dealloc];
}


@end
