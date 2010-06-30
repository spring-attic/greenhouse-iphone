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

@synthesize labelFirstName = _labelFirstName;
@synthesize labelLastName = _labelLastName;

- (IBAction)actionSignOut:(id)sender
{
	[[OAuthManager sharedInstance] removeAccessToken];
	[appDelegate showAuthorizeViewController];
}

- (IBAction)actionRefresh:(id)sender
{
	[self refreshData];
}

- (void)refreshData
{
	[[OAuthManager sharedInstance] fetchProfileDetailsWithDelegate:self 
												 didFinishSelector:@selector(showProfileDetails:) 
												   didFailSelector:@selector(showErrorMessage:)];	
}

- (void)showProfileDetails:(NSString *)details
{
	NSDictionary *dictionary = [details JSONValue];
	Person *person = [[Person alloc] initWithDictionary:dictionary];
	
	_labelFirstName.text = person.firstName;
	_labelLastName.text = person.lastName;
	
	[person release];
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
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	[self refreshData];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.labelFirstName = nil;
	self.labelLastName = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[_labelFirstName release];
	[_labelLastName release];
	
    [super dealloc];
}


@end
