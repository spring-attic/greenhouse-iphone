//
//  PullRefreshTableViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 8/27/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PullRefreshTableViewController : UITableViewController
{
	BOOL _reloading;
}

@property (assign,getter=isReloading) BOOL reloading;

- (void)reloadTableViewDataSource;
- (void)dataSourceDidFinishLoadingNewData;

@end