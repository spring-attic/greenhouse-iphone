//
//  EventSessionsViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/13/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EventSessionsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> 
{

}

@property (nonatomic, retain) IBOutlet UITableView *tableViewSessions;

@end
