//
//  Copyright 2010-2012 the original author or authors.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//
//  GHEventSessionRateViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/2/10.
//

#define MAX_MESSAGE_SIZE	140

#import "GHEventSessionRateViewController.h"
#import "Event.h"
#import "EventSession.h"
#import "GHEventController.h"
#import "GHEventSessionController.h"
#import "GHEventSessionDetailsViewController.h"
#import "GHActivityAlertView.h"

@interface GHEventSessionRateViewController ()

@property (nonatomic, strong) Event *event;
@property (nonatomic, strong) EventSession *session;
@property (nonatomic, assign) NSUInteger rating;
@property (nonatomic, strong) GHActivityAlertView *activityView;

- (void)updateRatingButtons:(NSInteger)count;
- (void)updateCharacterCount:(NSInteger)newCount;

@end

@implementation GHEventSessionRateViewController

@synthesize event;
@synthesize session;
@synthesize rating;
@synthesize activityView;
@synthesize sessionDetailsViewController;
@synthesize barButtonCancel;
@synthesize barButtonSubmit;
@synthesize buttonRating1;
@synthesize buttonRating2;
@synthesize buttonRating3;
@synthesize buttonRating4;
@synthesize buttonRating5;
@synthesize textViewComments;
@synthesize barButtonCount;


#pragma mark -
#pragma mark Public Instance methods

- (IBAction)actionSelectRating:(id)sender
{
	UIButton *button = (UIButton *)sender;
	[self updateRatingButtons:button.tag];
}

- (IBAction)actionCancel:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)actionSubmit:(id)sender
{
    if (self.rating == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"Please select a star rating"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    else if (self.rating > 0 && self.rating <= 5)
    {
        self.activityView = [[GHActivityAlertView alloc] initWithActivityMessage:@"Submitting rating..."];
        [activityView startAnimating];
        [[GHEventSessionController sharedInstance] rateSession:session.number
                                                   withEventId:event.eventId
                                                        rating:rating
                                                       comment:textViewComments.text
                                                      delegate:self];
    }
}


#pragma mark -
#pragma mark Private Instance methods

- (void)updateRatingButtons:(NSInteger)count
{
	UIImage *imageStar = [UIImage imageNamed:@"star.png"];
	UIImage *imageEmptyStar = [UIImage imageNamed:@"star-empty.png"];
	
	switch (count)
	{
		case 1:
			self.rating = 1;
			[buttonRating1 setImage:imageStar forState:UIControlStateNormal];
			[buttonRating2 setImage:imageEmptyStar forState:UIControlStateNormal];
			[buttonRating3 setImage:imageEmptyStar forState:UIControlStateNormal];
			[buttonRating4 setImage:imageEmptyStar forState:UIControlStateNormal];
			[buttonRating5 setImage:imageEmptyStar forState:UIControlStateNormal];
			break;
		case 2:
			self.rating = 2;
			[buttonRating1 setImage:imageStar forState:UIControlStateNormal];
			[buttonRating2 setImage:imageStar forState:UIControlStateNormal];
			[buttonRating3 setImage:imageEmptyStar forState:UIControlStateNormal];
			[buttonRating4 setImage:imageEmptyStar forState:UIControlStateNormal];
			[buttonRating5 setImage:imageEmptyStar forState:UIControlStateNormal];
			break;
		case 3:
			self.rating = 3;
			[buttonRating1 setImage:imageStar forState:UIControlStateNormal];
			[buttonRating2 setImage:imageStar forState:UIControlStateNormal];
			[buttonRating3 setImage:imageStar forState:UIControlStateNormal];
			[buttonRating4 setImage:imageEmptyStar forState:UIControlStateNormal];
			[buttonRating5 setImage:imageEmptyStar forState:UIControlStateNormal];
			break;
		case 4:
			self.rating = 4;
			[buttonRating1 setImage:imageStar forState:UIControlStateNormal];
			[buttonRating2 setImage:imageStar forState:UIControlStateNormal];
			[buttonRating3 setImage:imageStar forState:UIControlStateNormal];
			[buttonRating4 setImage:imageStar forState:UIControlStateNormal];
			[buttonRating5 setImage:imageEmptyStar forState:UIControlStateNormal];
			break;
		case 5:
			self.rating = 5;
			[buttonRating1 setImage:imageStar forState:UIControlStateNormal];
			[buttonRating2 setImage:imageStar forState:UIControlStateNormal];
			[buttonRating3 setImage:imageStar forState:UIControlStateNormal];
			[buttonRating4 setImage:imageStar forState:UIControlStateNormal];
			[buttonRating5 setImage:imageStar forState:UIControlStateNormal];
			break;
		case 0:
		default:
			self.rating = 0;
			[buttonRating1 setImage:imageEmptyStar forState:UIControlStateNormal];
			[buttonRating2 setImage:imageEmptyStar forState:UIControlStateNormal];
			[buttonRating3 setImage:imageEmptyStar forState:UIControlStateNormal];
			[buttonRating4 setImage:imageEmptyStar forState:UIControlStateNormal];
			[buttonRating5 setImage:imageEmptyStar forState:UIControlStateNormal];
			break;
	}	
}

- (void)updateCharacterCount:(NSInteger)newCount
{
	NSInteger remainingChars = MAX_MESSAGE_SIZE - newCount;
	NSString *s = [[NSString alloc] initWithFormat:@"%i", remainingChars];
	barButtonCount.title = s;
	
	if (remainingChars < 0)
	{
		barButtonSubmit.enabled = NO;
	}
	else 
	{
		barButtonSubmit.enabled = YES;
	}	
}


#pragma mark -
#pragma mark UITextViewDelegate methods

- (void)textViewDidChange:(UITextView *)textView
{
	[self updateCharacterCount:[textView.text length]];
}


#pragma mark -
#pragma mark EventSessionControllerDelegate methods

- (void)rateSessionDidFinishWithResults:(double)newRating
{
	session.rating = [NSNumber numberWithDouble:newRating];
    [activityView stopAnimating];
    self.activityView = nil;
	[self dismissModalViewControllerAnimated:YES];
}

- (void)rateSessionDidFailWithError:(NSError *)error
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
    
    self.event = [[GHEventController sharedInstance] fetchSelectedEvent];
    self.session = [[GHEventSessionController sharedInstance] fetchSelectedSession];
    if (self.event == nil || self.session == nil)
    {
        DLog(@"selected event or session not available");
        [self dismissModalViewControllerAnimated:NO];
    }
    else
    {
        textViewComments.text = @"";
        [self updateCharacterCount:0];
        [self updateRatingButtons:0];
        
        // display the keyboard
        [textViewComments becomeFirstResponder];
    }
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    DLog(@"");

    self.event = nil;
	self.session = nil;
	self.activityView = nil;
	self.sessionDetailsViewController = nil;
	self.barButtonCancel = nil;
	self.barButtonSubmit = nil;
	self.buttonRating1 = nil;
	self.buttonRating2 = nil;
	self.buttonRating3 = nil;
	self.buttonRating4 = nil;
	self.buttonRating5 = nil;
	self.textViewComments = nil;
	self.barButtonCount = nil;
}

@end
