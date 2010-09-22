//
//  ActivityAlertView.h
//  Greenhouse
//
//  Created by Roy Clarkson on 8/12/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ActivityAlertView : UIAlertView 
{ 
	UIActivityIndicatorView *_activityIndicatorView;
}

- (id)initWithActivityMessage:(NSString *)message;
- (void)startAnimating;
- (void)stopAnimating;

@end
