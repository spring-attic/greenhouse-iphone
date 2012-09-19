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
//  GHTweetDetailsViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 8/17/10.
//

#import <UIKit/UIKit.h>
#import "GHTwitterControllerDelegate.h"

@class Tweet;
@class GHTweetViewController;

@interface GHTweetDetailsViewController : UIViewController <GHTwitterControllerDelegate>

@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic, strong) IBOutlet UIImageView *imageViewProfile;
@property (nonatomic, strong) IBOutlet UILabel *labelUser;
@property (nonatomic, strong) IBOutlet UILabel *labelTime;
@property (nonatomic, strong) IBOutlet UITextView *textViewText;
@property (nonatomic, strong) IBOutlet UIButton *buttonReply;
@property (nonatomic, strong) IBOutlet UIButton *buttonRetweet;
@property (nonatomic, strong) IBOutlet UIButton *buttonQuote;
@property (nonatomic, strong) GHTweetViewController *tweetViewController;

- (IBAction)actionReply:(id)sender;
- (IBAction)actionRetweet:(id)sender;
- (IBAction)actionQuote:(id)sender;
- (void)sendRetweet;

@end
