//
//  VenueDetailsViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 10/4/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataViewController.h"


@class Venue;


@interface VenueDetailsViewController : DataViewController { }

@property (nonatomic, retain) Venue *venue;
@property (nonatomic, retain) IBOutlet UILabel *labelName;
@property (nonatomic, retain) IBOutlet UILabel *labelLocationHint;
@property (nonatomic, retain) IBOutlet UILabel *labelAddress;
@property (nonatomic, retain) IBOutlet UIButton *buttonDirections;

- (IBAction)actionGetDirections:(id)sender;

@end
