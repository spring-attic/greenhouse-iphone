    //
//  EventSessionRateViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/2/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "EventSessionRateViewController.h"

#define MAX_MESSAGE_SIZE	500


@interface EventSessionRateViewController()

- (void)updateRatingButtons:(NSInteger)count;

@property (nonatomic, retain) EventSessionController *eventSessionController;
@property (nonatomic, assign) NSUInteger rating;

@end


@implementation EventSessionRateViewController

@synthesize eventSessionController;
@synthesize rating;
@synthesize event;
@synthesize session;
@synthesize barButtonCancel;
@synthesize barButtonSubmit;
@synthesize buttonRating1;
@synthesize buttonRating2;
@synthesize buttonRating3;
@synthesize buttonRating4;
@synthesize buttonRating5;
@synthesize textViewComments;
@synthesize barButtonCount;

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
	self.eventSessionController = [EventSessionController eventSessionController];
	eventSessionController.delegate = self;
	
	[eventSessionController rateSession:session.number withEventId:event.eventId rating:rating comment:textViewComments.text];
}


#pragma mark -
#pragma mark UITextViewDelegate methods

- (void)textViewDidChange:(UITextView *)textView
{
	NSInteger remainingChars = MAX_MESSAGE_SIZE - textView.text.length;
	NSString *s = [[NSString alloc] initWithFormat:@"%i", remainingChars];
	barButtonCount.title = s;
	[s release];
	
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
#pragma mark EventSessionControllerDelegate methods

- (void)rateSessionDidFinish
{
	eventSessionController.delegate = nil;
	self.eventSessionController = nil;
	
	[self dismissModalViewControllerAnimated:YES];
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
	[self updateRatingButtons:0];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	// display the keyboard
	[textViewComments becomeFirstResponder];
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


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[eventSessionController release];
	[event release];
	[session release];
	[barButtonCancel release];
	[barButtonSubmit release];
	[buttonRating1 release];
	[buttonRating2 release];
	[buttonRating3 release];
	[buttonRating4 release];
	[buttonRating5 release];
	[textViewComments release];
	[barButtonCount release];
	
    [super dealloc];
}


@end
