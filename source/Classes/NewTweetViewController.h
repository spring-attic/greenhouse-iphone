//
//  NewTweetViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/23/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface NewTweetViewController : OAuthViewController <UITextViewDelegate, CLLocationManagerDelegate>
{
	
@private
	NSInteger remainingChars;
}

@property (nonatomic, retain) NSURL *tweetUrl;
@property (nonatomic, copy) NSString *hashtag;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *barButtonCancel;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *barButtonSend;
@property (nonatomic, retain) IBOutlet UITextView *textViewTweet;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *barButtonGeotag;
@property (nonatomic, retain) IBOutlet UISwitch *switchGeotag;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *barButtonCount;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *bestEffortLocation;


- (IBAction)actionCancel:(id)sender;
- (IBAction)actionSend:(id)sender;
- (IBAction)actionGeotag:(id)sender;

@end
