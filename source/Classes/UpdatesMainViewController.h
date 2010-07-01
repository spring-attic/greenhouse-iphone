//
//  UpdatesMainViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/1/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UpdatesMainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{

//@private
//	UIBarButtonItem *_barButtonRefresh;
//	UITableView *_tableViewUpdates;
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *barButtonRefresh;
@property (nonatomic, retain) IBOutlet UITableView *tableViewUpdates;

- (IBAction)actionRefresh:(id)sender;
- (void)refreshData;
- (void)showUpdates:(NSString *)details;
- (void)showErrorMessage:(NSError *)error;

@end
