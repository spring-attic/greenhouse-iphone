//
//  Venue.h
//  Greenhouse
//
//  Created by Roy Clarkson on 10/4/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebDataModel.h"
#import <MapKit/MapKit.h>


@interface Venue : NSObject <WebDataModel> { }

@property (nonatomic, copy) NSString *venueId;
@property (nonatomic, retain) CLLocation *location;
@property (nonatomic, copy) NSString *locationHint;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *postalAddress;

@end
