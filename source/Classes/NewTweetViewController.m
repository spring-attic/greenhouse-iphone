    //
//  NewTweetViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/23/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "NewTweetViewController.h"
#import "OAuthManager.h"

#define MAX_TWEET_SIZE 140


@interface NewTweetViewController()

- (void)setCount:(NSUInteger)newCount;

@end


@implementation NewTweetViewController

@synthesize hashtag;
@synthesize barButtonCancel;
@synthesize barButtonSend;
@synthesize textViewTweet;
@synthesize labelCount;

- (void)setCount:(NSUInteger)newCount
{
	remainingChars = MAX_TWEET_SIZE - newCount;
	NSString *s = [[NSString alloc] initWithFormat:@"%i", remainingChars];
	labelCount.text = s;
	[s release];
	
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

- (IBAction)actionSend:(id)sender
{
	NSURL *url = [[NSURL alloc] initWithString:EVENT_TWEETS_URL];

    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url 
																   consumer:[OAuthManager sharedInstance].consumer
																	  token:[OAuthManager sharedInstance].accessToken
																	  realm:OAUTH_REALM
														  signatureProvider:nil]; // use the default method, HMAC-SHA1
	
	[url release];
	
	NSString *s = [textViewTweet.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	
	DLog(@"tweet length: %i", s.length);
	
	NSString *postParams =[[NSString alloc] initWithFormat:@"status=%@", s];
	DLog(@"%@", postParams);

	NSString *escapedPostParams = [[postParams stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] retain];
	[postParams release];
	DLog(@"%@", escapedPostParams);
	
	NSData *postData = [[escapedPostParams dataUsingEncoding:NSUTF8StringEncoding] retain];
	[escapedPostParams release];
	
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
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
	[self setCount:range.location - range.length];
	
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
	
	textViewTweet.text = hashtag;
	[self setCount:[hashtag length]];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:YES];
	
	// displays the keyboard
	[textViewTweet becomeFirstResponder];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.hashtag = nil;
	self.barButtonCancel = nil;
	self.barButtonSend = nil;
	self.textViewTweet = nil;
	self.labelCount = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[hashtag release];
	[barButtonCancel release];
	[barButtonSend release];
	[textViewTweet release];
	[labelCount release];
	
    [super dealloc];
}


@end
