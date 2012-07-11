    //
//  TweetDetailsViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/17/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "TweetDetailsViewController.h"
#import "TweetViewController.h"
#import "OAuthManager.h"


@interface TweetDetailsViewController()

@property (nonatomic, retain) TwitterController *twitterController;

@end


@implementation TweetDetailsViewController

@synthesize twitterController;
@synthesize tweet;
@synthesize tweetUrl;
@synthesize retweetUrl;
@synthesize imageViewProfile;
@synthesize labelUser;
@synthesize labelTime;
@synthesize textViewText;
@synthesize buttonReply;
@synthesize buttonRetweet;
@synthesize buttonQuote;
@synthesize tweetViewController;

- (IBAction)actionReply:(id)sender
{
	tweetViewController.tweetUrl = tweetUrl;
	
	NSString *replyText = [[NSString alloc] initWithFormat:@"@%@", tweet.fromUser];
	tweetViewController.tweetText = replyText;
	[replyText release];
	
	[self presentModalViewController:tweetViewController animated:YES];
}

- (IBAction)actionQuote:(id)sender
{
	tweetViewController.tweetUrl = tweetUrl;
	
	NSString *quoteText = [[NSString alloc] initWithFormat:@"\"@%@: %@\"", tweet.fromUser, tweet.text];
	tweetViewController.tweetText = quoteText;
	[quoteText release];
	
	[self presentModalViewController:tweetViewController animated:YES];
}

- (IBAction)actionRetweet:(id)sender
{
	self.twitterController = [[TwitterController alloc] init];
	twitterController.delegate = self;
	
	[twitterController postRetweet:tweet.tweetId withURL:retweetUrl];
}


#pragma mark -
#pragma mark TwitterControllerDelegate methods

- (void)postRetweetDidFinish
{
	[twitterController release];
	self.twitterController = nil;
}

- (void)postRetweetDidFailWithError:(NSError *)error
{
	[twitterController release];
	self.twitterController = nil;
}

#pragma mark -
#pragma mark DataViewController methods

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


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.tweetViewController = [[TweetViewController alloc] initWithNibName:nil bundle:nil];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.twitterController = nil;
	self.tweet = nil;
	self.tweetUrl = nil;
	self.retweetUrl = nil;
    self.imageViewProfile = nil;
	self.labelUser = nil;
	self.textViewText = nil;
	self.buttonReply = nil;
	self.buttonRetweet = nil;
	self.buttonQuote = nil;
	self.tweetViewController = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[tweet release];
	[tweetUrl release];
	[retweetUrl release];
	[imageViewProfile release];
	[labelUser release];
	[textViewText release];
	[buttonReply release];
	[buttonRetweet release];
	[buttonQuote release];
	[tweetViewController release];
	
    [super dealloc];
}

@end
