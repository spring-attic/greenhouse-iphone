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

@synthesize labelFirstName;
@synthesize labelLastName;

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
	[self fetchJSONDataWithURL:[NSURL URLWithString:MEMBER_PROFILE_URL]];
}

- (void)fetchRequest:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	if (ticket.didSucceed)
	{
		NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSDictionary *dictionary = [responseBody JSONValue];
		[responseBody release];
		
		DLog(@"%@", dictionary); 
		
		Person *person = [[Person alloc] initWithDictionary:dictionary];
		
		labelFirstName.text = person.firstName;
		labelLastName.text = person.lastName;
		
		[person release];
	}
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
	[labelFirstName release];
	[labelLastName release];
	
    [super dealloc];
}


@end
