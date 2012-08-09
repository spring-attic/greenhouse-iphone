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
//  NewTweetViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/23/10.
//

#import "TweetViewController.h"
#import "OAuthManager.h"
#import "TwitterController.h"

#define MAX_TWEET_SIZE 140


@interface TweetViewController()

@property (nonatomic, strong) LocationManager *locationManager;
@property (nonatomic, strong) TwitterController *twitterController;

- (void)setCount:(NSUInteger)newCount;

@end


@implementation TweetViewController

@synthesize locationManager;
@synthesize twitterController;
@synthesize tweetUrl;
@synthesize tweetText;
@synthesize barButtonCancel;
@synthesize barButtonSend;
@synthesize textViewTweet;
@synthesize barButtonGeotag;
@synthesize switchGeotag;
@synthesize barButtonCount;

- (void)setCount:(NSUInteger)textLength
{
	NSInteger remainingChars = MAX_TWEET_SIZE - textLength;
	NSString *s = [[NSString alloc] initWithFormat:@"%i", remainingChars];
	barButtonCount.title = s;
	
	if (remainingChars < 0)
	{
		barButtonSend.enabled = NO;
	}
	else 
	{
		barButtonSend.enabled = YES;
	}	
}

- (IBAction)actionCancel:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)actionGeotag:(id)sender
{
	[UserSettings setIncludeLocationInTweet:switchGeotag.on];
}

- (IBAction)actionSend:(id)sender
{
	if ([UserSettings includeLocationInTweet])
	{
		self.locationManager = [[LocationManager alloc] init];
		locationManager.delegate = self;
		[locationManager startUpdatingLocation];
	}
	else 
	{
		self.twitterController = [[TwitterController alloc] init];
		twitterController.delegate = self;
		[twitterController postUpdate:textViewTweet.text withURL:tweetUrl];
	}
}


#pragma mark -
#pragma mark LocationManagerDelegate methods

- (void)locationManager:(LocationManager *)manager didUpdateLocation:(CLLocation *)newLocation
{
	self.locationManager = nil;
	self.twitterController = [[TwitterController alloc] init];
	twitterController.delegate = self;
	[twitterController postUpdate:textViewTweet.text withURL:tweetUrl location:newLocation];
}

- (void)locationManager:(LocationManager *)manager didFailWithError:(NSError *)error
{
	self.locationManager = nil;
}


#pragma mark -
#pragma mark TwitterControllerDelegate methods

- (void)postUpdateDidFinish
{
	self.twitterController = nil;
	[self dismissModalViewControllerAnimated:YES];
}

- (void)postUpdateDidFailWithError:(NSError *)error;
{
	self.twitterController = nil;
}


#pragma mark -
#pragma mark UITextViewDelegate methods

- (void)textViewDidChange:(UITextView *)textView
{
	[self setCount:[textView.text length]];
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
}
				   
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	self.switchGeotag.on = [UserSettings includeLocationInTweet];
	
	textViewTweet.text = tweetText;
	[self setCount:[tweetText length]];
	
	// displays the keyboard
	[textViewTweet becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:YES];	
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.locationManager = nil;
	self.twitterController = nil;
	self.tweetUrl = nil;
	self.tweetText = nil;
	self.barButtonCancel = nil;
	self.barButtonSend = nil;
	self.textViewTweet = nil;
	self.barButtonGeotag = nil;
	self.switchGeotag = nil;
	self.barButtonCount = nil;
}

@end
