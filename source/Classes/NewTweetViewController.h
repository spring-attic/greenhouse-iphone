//
//  NewTweetViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/23/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationManager.h"
#import "TwitterController.h"


@interface NewTweetViewController : OAuthViewController <UITextViewDelegate, LocationManagerDelegate, TwitterControllerDelegate>
{
	
}

@property (nonatomic, retain) NSURL *tweetUrl;
@property (nonatomic, copy) NSString *tweetText;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *barButtonCancel;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *barButtonSend;
@property (nonatomic, retain) IBOutlet UITextView *textViewTweet;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *barButtonGeotag;
@property (nonatomic, retain) IBOutlet UISwitch *switchGeotag;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *barButtonCount;


- (IBAction)actionCancel:(id)sender;
- (IBAction)actionSend:(id)sender;
- (IBAction)actionGeotag:(id)sender;

@end
