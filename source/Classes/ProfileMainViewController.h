//
//  ProfileMainViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 6/7/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProfileMainViewController : OAuthViewController <DataViewDelegate> 
{

}

@property (nonatomic, retain) IBOutlet UILabel *labelDisplayName;
@property (nonatomic, retain) IBOutlet WebImageView *imageViewPicture;

- (IBAction)actionSignOut:(id)sender;
- (void)refreshView;
- (void)fetchData;

@end
