//
//  NewTweetViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/23/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewTweetViewController : OAuthViewController <UITextViewDelegate>
{
	
@private
	NSInteger remainingChars;
}

@property (nonatomic, retain) NSURL *tweetUrl;
@property (nonatomic, copy) NSString *hashtag;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *barButtonCancel;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *barButtonSend;
@property (nonatomic, retain) IBOutlet UITextView *textViewTweet;
@property (nonatomic, retain) IBOutlet UILabel *labelCount;

- (IBAction)actionCancel:(id)sender;
- (IBAction)actionSend:(id)sender;

@end
