//
//  EventsMainViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/8/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EventsMainViewController : UIViewController {

}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *barButtonRefresh;
@property (nonatomic, retain) IBOutlet UITableView *tableViewEvents;

- (IBAction)actionRefresh:(id)sender;
- (void)refreshData;
- (void)showEvents:(NSString *)details;
- (void)showErrorMessage:(NSError *)error;

@end
