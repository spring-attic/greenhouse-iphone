    //
//  TweetDetailsViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/17/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "TweetDetailsViewController.h"


@implementation TweetDetailsViewController

@synthesize tweet;
@synthesize imageViewProfile;
@synthesize labelUser;
@synthesize labelTime;
@synthesize textViewText;
@synthesize buttonReply;
@synthesize buttonRetweet;
@synthesize buttonQuote;

- (IBAction)actionReply:(id)sender
{
	// TODO: tweet reply
}

- (IBAction)actionRetweet:(id)sender
{
	// TODO: tweet reply
}

- (IBAction)actionQuote:(id)sender
{
	// TODO: tweet quote
}


#pragma mark -
#pragma mark DataViewDelegate methods

- (void)refreshView
{
	if (tweet)
	{
		imageViewProfile.image = tweet.profileImage;
		
		NSString *user = [[NSString alloc] initWithFormat:@"@%@", tweet.fromUser];
		labelUser.text = user;
		[user release];
		
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"MMM d h:mm a"];
		labelTime.text = [dateFormatter stringFromDate:tweet.createdAt];
		[dateFormatter release];

		textViewText.text = tweet.text;
	}
}

- (void)fetchData
{
}

#pragma mark -
#pragma mark UIViewController methods

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
	
	self.tweet = nil;
    self.imageViewProfile = nil;
	self.labelUser = nil;
	self.textViewText = nil;
	self.buttonReply = nil;
	self.buttonRetweet = nil;
	self.buttonQuote = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[tweet release];
	[imageViewProfile release];
	[labelUser release];
	[textViewText release];
	[buttonReply release];
	[buttonRetweet release];
	[buttonQuote release];
	
    [super dealloc];
}

@end
