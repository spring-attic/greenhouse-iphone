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
- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

@end


@implementation NewTweetViewController

@synthesize tweetUrl;
@synthesize tweetText;
@synthesize barButtonCancel;
@synthesize barButtonSend;
@synthesize textViewTweet;
@synthesize barButtonGeotag;
@synthesize switchGeotag;
@synthesize barButtonCount;
@synthesize locationManager;
@synthesize bestEffortLocation;

- (void)setCount:(NSUInteger)newCount
{

}

- (IBAction)actionCancel:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)actionGeotag:(id)sender
{
	[[UserSettings sharedInstance] setIncludeLocationInTweet:switchGeotag.on];
	
	if ([[UserSettings sharedInstance] includeLocationInTweet])
	{
		[self startUpdatingLocation];
	}
	else 
	{
		[self stopUpdatingLocation];
	}
}

- (void)startUpdatingLocation
{
	self.locationManager = [[[CLLocationManager alloc] init] autorelease];
	locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
	[locationManager startUpdatingLocation];
	
	// create a timer to stop the locationManager after 45 seconds
	[self performSelector:@selector(stopUpdatingLocation) withObject:nil afterDelay:45.0];
}

- (void)stopUpdatingLocation
{
	[locationManager stopUpdatingLocation];
	locationManager.delegate = nil;
}

- (IBAction)actionSend:(id)sender
{
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:tweetUrl 
																   consumer:[OAuthManager sharedInstance].consumer
																	  token:[OAuthManager sharedInstance].accessToken
																	  realm:OAUTH_REALM
														  signatureProvider:nil]; // use the default method, HMAC-SHA1
	
	NSString *s = [textViewTweet.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	DLog(@"tweet length: %i", s.length);
	
	double latitude = 0.0;
	double longitude = 0.0;
	
	if (switchGeotag.on && bestEffortLocation)
	{
		latitude = bestEffortLocation.coordinate.latitude;
		longitude = bestEffortLocation.coordinate.longitude;
	}
	
	NSString *postParams =[[NSString alloc] initWithFormat:@"status=%@&latitude=%f&longitude=%f", s, latitude, longitude];
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
#pragma mark CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation 
{
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
	
	// make sure we aren't using an old, cached location
    if (locationAge > 10.0)
	{
		return;
	}
	
    // a negative horizontal accuracy means the location is invalid
    if (newLocation.horizontalAccuracy < 0)
	{
		return;
	}
	
    // test the measurement to see if it is more accurate than the previous measurement
    if (bestEffortLocation == nil || bestEffortLocation.horizontalAccuracy > newLocation.horizontalAccuracy) 
	{
        self.bestEffortLocation = newLocation;

		// stop locating once we get a fix that meets our accuracy requirements
        if (newLocation.horizontalAccuracy <= locationManager.desiredAccuracy) 
		{
			[self stopUpdatingLocation];

            // we can also cancel our previous performSelector:withObject:afterDelay: - it's no longer necessary
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopUpdatingLocation) object:nil];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error 
{
    if ([error code] != kCLErrorLocationUnknown) 
	{
		[self stopUpdatingLocation];
    }
}


#pragma mark -
#pragma mark UITextViewDelegate methods

- (void)textViewDidChange:(UITextView *)textView
{
	NSInteger remainingChars = MAX_TWEET_SIZE - textView.text.length;
	NSString *s = [[NSString alloc] initWithFormat:@"%i", remainingChars];
	barButtonCount.title = s;
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


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.switchGeotag.on = [[UserSettings sharedInstance] includeLocationInTweet];
}
				   
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	textViewTweet.text = tweetText;
	[self setCount:[tweetText length]];
	
	if ([[UserSettings sharedInstance] includeLocationInTweet])
	{
		[self startUpdatingLocation];
	}
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
	
	self.tweetUrl = nil;
	self.tweetText = nil;
	self.barButtonCancel = nil;
	self.barButtonSend = nil;
	self.textViewTweet = nil;
	self.barButtonGeotag = nil;
	self.switchGeotag = nil;
	self.barButtonCount = nil;
	self.locationManager = nil;
	self.bestEffortLocation = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[tweetUrl release];
	[tweetText release];
	[barButtonCancel release];
	[barButtonSend release];
	[textViewTweet release];
	[barButtonGeotag release];
	[switchGeotag release];
	[barButtonCount release];
	[locationManager release];
	[bestEffortLocation release];
	
    [super dealloc];
}


@end
