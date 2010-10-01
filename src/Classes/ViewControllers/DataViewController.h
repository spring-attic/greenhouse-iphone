//
//  DataViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 9/8/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DataViewController : UIViewController { }

- (void)refreshView;
- (void)reloadData;
- (BOOL)shouldReloadData;

@end
