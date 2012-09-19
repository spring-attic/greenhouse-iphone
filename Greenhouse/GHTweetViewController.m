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
//  GHTweetViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/23/10.
//

#define MAX_TWEET_SIZE 140

#import "GHTweetViewController.h"
#import "GHTwitterController.h"
#import "GHActivityAlertView.h"

@interface GHTweetViewController ()

@property (nonatomic, strong) GHActivityAlertView *activityView;
- (void)setCount:(NSUInteger)newCount;

@end

@implementation GHTweetViewController

@synthesize activityView;
@synthesize tweetText;
@synthesize barButtonCancel;
@synthesize barButtonSend;
@synthesize textViewTweet;
@synthesize barButtonCount;


#pragma mark -
#pragma Public Instance methods

- (IBAction)actionCancel:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)actionSend:(id)sender
{
    self.activityView = [[GHActivityAlertView alloc] initWithActivityMessage:@"Updating status..."];
    [activityView startAnimating];
    [self sendTweet:self.textViewTweet.text];
}

- (void)sendTweet:(NSString *)text
{
    // implented in subclass
}

#pragma mark -
#pragma mark Private Instance methods

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


#pragma mark -
#pragma mark GHTwitterControllerDelegate methods

- (void)postUpdateDidFinish
{
    [activityView stopAnimating];
    self.activityView = nil;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Tweet successful!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
	[self dismissModalViewControllerAnimated:YES];
}

- (void)postUpdateDidFailWithError:(NSError *)error;
{
    [activityView stopAnimating];
    self.activityView = nil;
    [self dismissModalViewControllerAnimated:YES];
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
    DLog(@"");
}
				   
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    DLog(@"");
	
	textViewTweet.text = tweetText;
	[self setCount:[tweetText length]];
	
	// displays the keyboard
	[textViewTweet becomeFirstResponder];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    DLog(@"");
	
    self.activityView = nil;
	self.tweetText = nil;
	self.barButtonCancel = nil;
	self.barButtonSend = nil;
	self.textViewTweet = nil;
	self.barButtonCount = nil;
}

@end
