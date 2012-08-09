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
//  EventSessionRateViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/2/10.
//

#import "EventSessionRateViewController.h"
#import "Event.h"
#import "EventSession.h"
#import "EventSessionDetailsViewController.h"

#define MAX_MESSAGE_SIZE	140


@interface EventSessionRateViewController()

@property (nonatomic, strong) EventSessionController *eventSessionController;
@property (nonatomic, assign) NSUInteger rating;

- (void)updateRatingButtons:(NSInteger)count;
- (void)updateCharacterCount:(NSInteger)newCount;

@end


@implementation EventSessionRateViewController

@synthesize eventSessionController;
@synthesize rating;
@synthesize event;
@synthesize session;
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
#pragma mark Public methods

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
	self.eventSessionController = [[EventSessionController alloc] init];
	eventSessionController.delegate = self;
	
	[eventSessionController rateSession:session.number withEventId:event.eventId rating:rating comment:textViewComments.text];
}


#pragma mark -
#pragma mark Private methods

- (void)updateRatingButtons:(NSInteger)count
{
	UIImage *imageStar = [UIImage imageNamed:@"star.png"];
	UIImage *imageEmptyStar = [UIImage imageNamed:@"star-empty.png"];
	
	switch (count)
	{
		case 1:
			rating = 1;
			[buttonRating1 setImage:imageStar forState:UIControlStateNormal];
			[buttonRating2 setImage:imageEmptyStar forState:UIControlStateNormal];
			[buttonRating3 setImage:imageEmptyStar forState:UIControlStateNormal];
			[buttonRating4 setImage:imageEmptyStar forState:UIControlStateNormal];
			[buttonRating5 setImage:imageEmptyStar forState:UIControlStateNormal];
			break;
		case 2:
			rating = 2;
			[buttonRating1 setImage:imageStar forState:UIControlStateNormal];
			[buttonRating2 setImage:imageStar forState:UIControlStateNormal];
			[buttonRating3 setImage:imageEmptyStar forState:UIControlStateNormal];
			[buttonRating4 setImage:imageEmptyStar forState:UIControlStateNormal];
			[buttonRating5 setImage:imageEmptyStar forState:UIControlStateNormal];
			break;
		case 3:
			rating = 3;
			[buttonRating1 setImage:imageStar forState:UIControlStateNormal];
			[buttonRating2 setImage:imageStar forState:UIControlStateNormal];
			[buttonRating3 setImage:imageStar forState:UIControlStateNormal];
			[buttonRating4 setImage:imageEmptyStar forState:UIControlStateNormal];
			[buttonRating5 setImage:imageEmptyStar forState:UIControlStateNormal];
			break;
		case 4:
			rating = 4;
			[buttonRating1 setImage:imageStar forState:UIControlStateNormal];
			[buttonRating2 setImage:imageStar forState:UIControlStateNormal];
			[buttonRating3 setImage:imageStar forState:UIControlStateNormal];
			[buttonRating4 setImage:imageStar forState:UIControlStateNormal];
			[buttonRating5 setImage:imageEmptyStar forState:UIControlStateNormal];
			break;
		case 5:
			rating = 5;
			[buttonRating1 setImage:imageStar forState:UIControlStateNormal];
			[buttonRating2 setImage:imageStar forState:UIControlStateNormal];
			[buttonRating3 setImage:imageStar forState:UIControlStateNormal];
			[buttonRating4 setImage:imageStar forState:UIControlStateNormal];
			[buttonRating5 setImage:imageStar forState:UIControlStateNormal];
			break;
		case 0:
		default:
			rating = 0;
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
	self.eventSessionController = nil;
	
	session.rating = newRating;
	[sessionDetailsViewController updateRating:newRating];
	
	[self dismissModalViewControllerAnimated:YES];
}

- (void)rateSessionDidFailWithError:(NSError *)error
{
	self.eventSessionController = nil;
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
	
	textViewComments.text = @"";
	[self updateCharacterCount:0];
	[self updateRatingButtons:0];
	
	// display the keyboard
	[textViewComments becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];	
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.eventSessionController = nil;
	self.event = nil;
	self.sessionDetailsViewController = nil;
	self.session = nil;
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
