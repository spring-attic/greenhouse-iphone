    //
//  TweetDetailsViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/17/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "TweetDetailsViewController.h"
#import "newTweetViewController.h"
#import "OAuthManager.h"


@implementation TweetDetailsViewController

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
@synthesize newTweetViewController;

- (IBAction)actionReply:(id)sender
{
	newTweetViewController.tweetUrl = tweetUrl;
	
	NSString *replyText = [[NSString alloc] initWithFormat:@"@%@", tweet.fromUser];
	newTweetViewController.tweetText = replyText;
	[replyText release];
	
	[self presentModalViewController:newTweetViewController animated:YES];
}

- (IBAction)actionQuote:(id)sender
{
	newTweetViewController.tweetUrl = tweetUrl;
	
	NSString *quoteText = [[NSString alloc] initWithFormat:@"\"@%@: %@\"", tweet.fromUser, tweet.text];
	newTweetViewController.tweetText = quoteText;
	[quoteText release];
	
	[self presentModalViewController:newTweetViewController animated:YES];
}

- (IBAction)actionRetweet:(id)sender
{
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:retweetUrl 
																   consumer:[OAuthManager sharedInstance].consumer
																	  token:[OAuthManager sharedInstance].accessToken
																	  realm:OAUTH_REALM
														  signatureProvider:nil]; // use the default method, HMAC-SHA1
		
	NSString *postParams =[[NSString alloc] initWithFormat:@"tweetId=%@", tweet.tweetId];
	DLog(@"%@", postParams);
	
	NSString *escapedPostParams = [[postParams stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] retain];
	[postParams release];
	DLog(@"%@", escapedPostParams);
	
	NSData *postData = [[escapedPostParams dataUsingEncoding:NSUTF8StringEncoding] retain];
	[escapedPostParams release];
	
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:postData];
	[postData release];
	
	DLog(@"%@", request);
	
	OADataFetcher *fetcher = [[OADataFetcher alloc] init];
	
	[fetcher fetchDataWithRequest:request
						 delegate:self
				didFinishSelector:@selector(fetchRequest:didFinishWithData:)
				  didFailSelector:@selector(fetchRequest:didFailWithError:)];
	
	[request release];
}

- (void)fetchRequest:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	NSHTTPURLResponse *response = (NSHTTPURLResponse *)ticket.response;
	
	if (ticket.didSucceed)
	{
		[self dismissModalViewControllerAnimated:YES];
		
		NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		DLog(@"%@", responseBody);
		[responseBody release];
		
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil 
															message:@"Retweet successful!" 
														   delegate:nil 
												  cancelButtonTitle:@"OK" 
												  otherButtonTitles:nil];
		[alertView show];
		[alertView release];		
	}
	else if ([response statusCode] == 412)
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" 
															message:@"Your account is not connected to Twitter.  Please sign in to greenhouse.springsource.org to connect." 
														   delegate:nil 
												  cancelButtonTitle:@"OK" 
												  otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
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
	self.retweetUrl = nil;
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
	[retweetUrl release];
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
