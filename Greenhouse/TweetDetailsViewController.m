//
//  Copyright 2010-2012 the original author or authors.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//
//  TweetDetailsViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/17/10.
//

#import "TweetDetailsViewController.h"
#import "TweetViewController.h"
#import "OAuthManager.h"


@interface TweetDetailsViewController()

@property (nonatomic, strong) TwitterController *twitterController;

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
	
	[self presentModalViewController:tweetViewController animated:YES];
}

- (IBAction)actionQuote:(id)sender
{
	tweetViewController.tweetUrl = tweetUrl;
	
	NSString *quoteText = [[NSString alloc] initWithFormat:@"\"@%@: %@\"", tweet.fromUser, tweet.text];
	tweetViewController.tweetText = quoteText;
	
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
	self.twitterController = nil;
}

- (void)postRetweetDidFailWithError:(NSError *)error
{
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
		
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"MMM d h:mm a"];
		labelTime.text = [dateFormatter stringFromDate:tweet.createdAt];
		
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

@end
