//
//  MainViewController.m
//  OAuthSample
//
//  Created by Roy Clarkson on 5/27/10.
//  Copyright VMware 2010. All rights reserved.
//

#import "OAuthSampleViewController.h"
#import "OAuthManager.h"


@implementation OAuthSampleViewController

@synthesize buttonSignIn = _buttonSignIn;
@synthesize buttonUpdateStatus = _buttonUpdateStatus;
@synthesize textStatus = _textStatus;


#pragma mark -
#pragma mark Public methods
#pragma mark

- (IBAction)actionSignIn:(id)sender
{
	[[OAuthManager sharedInstance] fetchUnauthorizedRequestToken];
}

- (IBAction)actionUpdateStatus:(id)sender
{
	[[OAuthManager sharedInstance] updateStatus:_textStatus.text];
}


#pragma mark -
#pragma mark UITextFieldDelegate methods
#pragma mark

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	
	return YES;
}


#pragma mark -
#pragma mark UIViewController methods
#pragma mark

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
	self.buttonSignIn = nil;
	self.buttonUpdateStatus = nil;
	self.textStatus = nil;
}


#pragma mark -
#pragma mark NSObject methods
#pragma mark

- (void)dealloc 
{
	[_buttonSignIn release];
	[_buttonUpdateStatus release];
	[_textStatus release];
	
    [super dealloc];
}

@end
