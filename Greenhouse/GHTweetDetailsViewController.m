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
//  GHTweetDetailsViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/17/10.
//

#import "GHTweetDetailsViewController.h"
#import "GHTweetViewController.h"
#import "Tweet.h"
#import "GHTwitterController.h"
#import "GHActivityAlertView.h"

@interface GHTweetDetailsViewController ()

@property (nonatomic, strong) GHActivityAlertView *activityView;

@end

@implementation GHTweetDetailsViewController

@synthesize activityView;
@synthesize tweet;
@synthesize imageViewProfile;
@synthesize labelUser;
@synthesize labelTime;
@synthesize textViewText;
@synthesize buttonReply;
@synthesize buttonRetweet;
@synthesize buttonQuote;
@synthesize tweetViewController;


#pragma mark -
#pragma mark Public Instance methods

- (IBAction)actionReply:(id)sender
{
	tweetViewController.tweetText = [[NSString alloc] initWithFormat:@"@%@", tweet.fromUser];
	[self presentModalViewController:tweetViewController animated:YES];
}

- (IBAction)actionQuote:(id)sender
{
	tweetViewController.tweetText = [[NSString alloc] initWithFormat:@"\"@%@: %@\"", tweet.fromUser, tweet.text];
	[self presentModalViewController:tweetViewController animated:YES];
}

- (IBAction)actionRetweet:(id)sender
{
    self.activityView = [[GHActivityAlertView alloc] initWithActivityMessage:@"Retweeting status..."];
    [activityView startAnimating];
    [self sendRetweet];
}

- (void)sendRetweet
{
    // implemented in subclass
}


#pragma mark -
#pragma mark TwitterControllerDelegate methods

- (void)postRetweetDidFinish
{
    [activityView stopAnimating];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Retweet successful!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
    self.activityView = nil;
}

- (void)postRetweetDidFailWithError:(NSError *)error
{
    [activityView stopAnimating];
    self.activityView = nil;
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
    DLog(@"");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DLog(@"");
    
    self.tweet = [[GHTwitterController sharedInstance] fetchSelectedTweet];
    
    if (tweet)
	{
        if (tweet.profileImage)
        {
            imageViewProfile.image = tweet.profileImage;
        }
        else
        {
            imageViewProfile.image = [UIImage imageNamed:@"twitter-logo.png"];
        }
		labelUser.text = [[NSString alloc] initWithFormat:@"@%@", tweet.fromUser];
		textViewText.text = tweet.text;        
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"MMM d h:mm a"];
		labelTime.text = [dateFormatter stringFromDate:tweet.createdAt];
	}
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    DLog(@"");

	self.activityView = nil;
	self.tweet = nil;
    self.imageViewProfile = nil;
	self.labelUser = nil;
	self.textViewText = nil;
	self.buttonReply = nil;
	self.buttonRetweet = nil;
	self.buttonQuote = nil;
	self.tweetViewController = nil;
}

@end
