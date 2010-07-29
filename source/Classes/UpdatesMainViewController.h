//
//  UpdatesMainViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/1/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UpdatesMainViewController : OAuthViewController <DataViewDelegate, UITableViewDelegate, UITableViewDataSource> 
{

}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *barButtonRefresh;
@property (nonatomic, retain) IBOutlet UITableView *tableViewUpdates;

- (IBAction)actionRefresh:(id)sender;

- (void)refreshView;
- (void)fetchData;

@end
