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
	UILabel *_labelId;
	UILabel *_labelVersion;
	UILabel *_labelFirstName;
	UILabel *_labelLastName;
	UILabel *_labelEmailAddress;
}

@property (nonatomic, retain) IBOutlet UILabel *labelId;
@property (nonatomic, retain) IBOutlet UILabel *labelVersion;
@property (nonatomic, retain) IBOutlet UILabel *labelFirstName;
@property (nonatomic, retain) IBOutlet UILabel *labelLastName;
@property (nonatomic, retain) IBOutlet UILabel *labelEmailAddress;


- (void)showProfileDetails:(NSString *)details;

@end
