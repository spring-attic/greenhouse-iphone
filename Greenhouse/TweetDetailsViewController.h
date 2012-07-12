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
//  TweetDetailsViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 8/17/10.
//

#import <UIKit/UIKit.h>
#import "TwitterController.h"
#import "Tweet.h"


@class TweetViewController;


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
@property (nonatomic, retain) TweetViewController *tweetViewController;

- (IBAction)actionReply:(id)sender;
- (IBAction)actionRetweet:(id)sender;
- (IBAction)actionQuote:(id)sender;

@end
