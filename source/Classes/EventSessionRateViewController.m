    //
//  EventSessionRateViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/2/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "EventSessionRateViewController.h"
#import "OAuthManager.h"


@interface EventSessionRateViewController()

- (void)updateRatingButtons:(NSInteger)count;

@property (nonatomic, assign) NSUInteger rating;

@end


@implementation EventSessionRateViewController

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

- (void)updateRatingButtons:(NSInteger)count
{
	switch (count)
	{
		case 1:
			rating = 1;
			[buttonRating1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
			[buttonRating2 setTitleColor:[UIColor springDarkGreenColor] forState:UIControlStateNormal];
			[buttonRating3 setTitleColor:[UIColor springDarkGreenColor] forState:UIControlStateNormal];
			[buttonRating4 setTitleColor:[UIColor springDarkGreenColor] forState:UIControlStateNormal];
			[buttonRating5 setTitleColor:[UIColor springDarkGreenColor] forState:UIControlStateNormal];
			break;
		case 2:
			rating = 2;
			[buttonRating1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
			[buttonRating2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
			[buttonRating3 setTitleColor:[UIColor springDarkGreenColor] forState:UIControlStateNormal];
			[buttonRating4 setTitleColor:[UIColor springDarkGreenColor] forState:UIControlStateNormal];
			[buttonRating5 setTitleColor:[UIColor springDarkGreenColor] forState:UIControlStateNormal];
			break;
		case 3:
			rating = 3;
			[buttonRating1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
			[buttonRating2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
			[buttonRating3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
			[buttonRating4 setTitleColor:[UIColor springDarkGreenColor] forState:UIControlStateNormal];
			[buttonRating5 setTitleColor:[UIColor springDarkGreenColor] forState:UIControlStateNormal];
			break;
		case 4:
			rating = 4;
			[buttonRating1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
			[buttonRating2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
			[buttonRating3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
			[buttonRating4 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
			[buttonRating5 setTitleColor:[UIColor springDarkGreenColor] forState:UIControlStateNormal];
			break;
		case 5:
			rating = 5;
			[buttonRating1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
			[buttonRating2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
			[buttonRating3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
			[buttonRating4 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
			[buttonRating5 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
			break;
		case 0:
		default:
			rating = 0;
			[buttonRating1 setTitleColor:[UIColor springDarkGreenColor] forState:UIControlStateNormal];
			[buttonRating2 setTitleColor:[UIColor springDarkGreenColor] forState:UIControlStateNormal];
			[buttonRating3 setTitleColor:[UIColor springDarkGreenColor] forState:UIControlStateNormal];
			[buttonRating4 setTitleColor:[UIColor springDarkGreenColor] forState:UIControlStateNormal];
			[buttonRating5 setTitleColor:[UIColor springDarkGreenColor] forState:UIControlStateNormal];			
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
	NSString *urlString = [[NSString alloc] initWithFormat:EVENT_SESSION_RATING_URL, event.eventId, session.number];
	NSURL *url = [[NSURL alloc] initWithString:urlString];
	[urlString release];
	
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url 
																   consumer:[OAuthManager sharedInstance].consumer
																	  token:[OAuthManager sharedInstance].accessToken
																	  realm:OAUTH_REALM
														  signatureProvider:nil]; // use the default method, HMAC-SHA1
	
	[url release];
	
	NSString *comment = [textViewComments.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	
	NSString *putParams =[[NSString alloc] initWithFormat:@"value=%i&comment=%@", rating, comment];
	DLog(@"%@", putParams);
	
	NSString *escapedPutParams = [[putParams stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] retain];
	[putParams release];
	DLog(@"%@", escapedPutParams);
	
	NSData *putData = [[escapedPutParams dataUsingEncoding:NSUTF8StringEncoding] retain];
	[escapedPutParams release];
	
	NSString *putLength = [NSString stringWithFormat:@"%d", [putData length]];
	
	[request setHTTPMethod:@"PUT"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setValue:putLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:putData];
	[putData release];
	
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
	if (ticket.didSucceed)
	{
		[self dismissModalViewControllerAnimated:YES];
		
		NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		DLog(@"%@", responseBody);
		[responseBody release];
	}	
}


#pragma mark -
#pragma mark UITextViewDelegate methods

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
//	[self setCount:range.location - range.length];
	
	return YES;
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
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
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
	
    [super dealloc];
}


@end
