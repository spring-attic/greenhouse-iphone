//
//  Copyright 2010-2012 the original author or authors.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//
//  VenueDetailsViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 10/4/10.
//

#import <UIKit/UIKit.h>
#import "DataViewController.h"


@class Venue;


@interface VenueDetailsViewController : DataViewController

@property (nonatomic, strong) Venue *venue;
@property (nonatomic, strong) IBOutlet UILabel *labelName;
@property (nonatomic, strong) IBOutlet UILabel *labelLocationHint;
@property (nonatomic, strong) IBOutlet UILabel *labelAddress;
@property (nonatomic, strong) IBOutlet UIButton *buttonDirections;

- (IBAction)actionGetDirections:(id)sender;

@end
