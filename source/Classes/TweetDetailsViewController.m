    //
//  TweetDetailsViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/17/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "TweetDetailsViewController.h"
#import "newTweetViewController.h"


@implementation TweetDetailsViewController

@synthesize tweet;
@synthesize tweetUrl;
@synthesize imageViewProfile;
@synthesize labelUser;
@synthesize labelTime;
@synthesize textViewText;
@synthesize buttonReply;
@synthesize buttonRetweet;
@synthesize buttonQuote;
@synthesize newTweetViewController;

- (IBAction)actionReply:(id)sender
{
	newTweetViewController.tweetUrl = tweetUrl;
	
	NSString *replyText = [[NSString alloc] initWithFormat:@"@%@", tweet.fromUser];
	newTweetViewController.tweetText = replyText;
	[replyText release];
	
	[self presentModalViewController:newTweetViewController animated:YES];
}

- (IBAction)actionRetweet:(id)sender
{
	// TODO: tweet retweet
}

- (IBAction)actionQuote:(id)sender
{
	newTweetViewController.tweetUrl = tweetUrl;
	
	NSString *quoteText = [[NSString alloc] initWithFormat:@"\"@%@: %@\"", tweet.fromUser, tweet.text];
	newTweetViewController.tweetText = quoteText;
	[quoteText release];
	
	[self presentModalViewController:newTweetViewController animated:YES];
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
	
	self.newTweetViewController = [[NewTweetViewController alloc] initWithNibName:nil bundle:nil];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.tweet = nil;
	self.tweetUrl = nil;
    self.imageViewProfile = nil;
	self.labelUser = nil;
	self.textViewText = nil;
	self.buttonReply = nil;
	self.buttonRetweet = nil;
	self.buttonQuote = nil;
	self.newTweetViewController = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[tweet release];
	[tweetUrl release];
	[imageViewProfile release];
	[labelUser release];
	[textViewText release];
	[buttonReply release];
	[buttonRetweet release];
	[buttonQuote release];
	[newTweetViewController release];
	
    [super dealloc];
}

@end
