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
//  NewTweetViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/23/10.
//

#import <UIKit/UIKit.h>
#import "LocationManager.h"
#import "TwitterController.h"


@interface TweetViewController : UIViewController <UITextViewDelegate, LocationManagerDelegate, TwitterControllerDelegate>

@property (nonatomic, strong) NSURL *tweetUrl;
@property (nonatomic, copy) NSString *tweetText;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *barButtonCancel;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *barButtonSend;
@property (nonatomic, strong) IBOutlet UITextView *textViewTweet;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *barButtonGeotag;
@property (nonatomic, strong) IBOutlet UISwitch *switchGeotag;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *barButtonCount;


- (IBAction)actionCancel:(id)sender;
- (IBAction)actionSend:(id)sender;
- (IBAction)actionGeotag:(id)sender;

@end
