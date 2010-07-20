//
//  ProfileMainViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 6/7/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProfileMainViewController : OAuthViewController 
{

}

@property (nonatomic, retain) IBOutlet UILabel *labelFirstName;
@property (nonatomic, retain) IBOutlet UILabel *labelLastName;

- (IBAction)actionSignOut:(id)sender;
- (IBAction)actionRefresh:(id)sender;
- (void)refreshData;

@end
