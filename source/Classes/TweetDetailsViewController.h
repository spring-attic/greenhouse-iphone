//
//  TweetDetailsViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 8/17/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterController.h"
#import "Tweet.h"


@class NewTweetViewController;


@interface TweetDetailsViewController : DataViewController <TwitterControllerDelegate> { }

@property (nonatomic, retain) Tweet *tweet;
@property (nonatomic, retain) NSURL *tweetUrl;
@property (nonatomic, retain) NSURL *retweetUrl;
@property (nonatomic, retain) IBOutlet UIImageView *imageViewProfile;
@property (nonatomic, retain) IBOutlet UILabel *labelUser;
@property (nonatomic, retain) IBOutlet UILabel *labelTime;
@property (nonatomic, retain) IBOutlet UITextView *textViewText;
@property (nonatomic, retain) IBOutlet UIButton *buttonReply;
@property (nonatomic, retain) IBOutlet UIButton *buttonRetweet;
@property (nonatomic, retain) IBOutlet UIButton *buttonQuote;
@property (nonatomic, retain) NewTweetViewController *newTweetViewController;

- (IBAction)actionReply:(id)sender;
- (IBAction)actionRetweet:(id)sender;
- (IBAction)actionQuote:(id)sender;

@end
