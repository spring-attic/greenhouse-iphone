//
//  MainViewController.h
//  OAuthSample
//
//  Created by Roy Clarkson on 5/27/10.
//  Copyright VMware 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthConsumer.h"


@interface OAuthSampleViewController : UIViewController <UITextFieldDelegate>
{
	UIButton *_buttonSignIn;
	UIButton *_buttonUpdateStatus;
	UITextField *_textStatus;
}

@property (nonatomic, retain) IBOutlet UIButton *buttonSignIn;
@property (nonatomic, retain) IBOutlet UIButton *buttonUpdateStatus;
@property (nonatomic, retain) IBOutlet UITextField *textStatus;

- (IBAction)actionSignIn:(id)sender;
- (IBAction)actionUpdateStatus:(id)sender;

@end

