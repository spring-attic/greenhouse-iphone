//
//  NewTweetViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/23/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewTweetViewController : UIViewController <UITextViewDelegate>
{

}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *barButtonCancel;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *barButtonSend;
@property (nonatomic, retain) IBOutlet UITextView *textViewDelegate;

- (IBAction)actionCancel:(id)sender;
- (IBAction)actionSend:(id)sender;

@end
