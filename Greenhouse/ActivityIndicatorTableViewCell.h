//
//  ActivityIndicatorTableViewCell.h
//  Greenhouse
//
//  Created by Roy Clarkson on 9/24/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ActivityIndicatorTableViewCell : UITableViewCell 
{ 
	UIActivityIndicatorView *_activityIndicatorView;
	UIView *_accessoryViewRef;
}

- (void)startAnimating;
- (void)stopAnimating;

@end
