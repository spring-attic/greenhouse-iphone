//
//  ProfileMainViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 6/7/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProfileMainViewController : UIViewController 
{

@private
	UITextView *_textView;
}

@property (nonatomic, retain) IBOutlet UITextView *textView;

- (void)showProfileDetails:(NSString *)details;

@end
