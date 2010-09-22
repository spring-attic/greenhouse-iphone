//
//  LocationManagerDelegate.h
//  Greenhouse
//
//  Created by Roy Clarkson on 9/21/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@class LocationManager;


@protocol LocationManagerDelegate

- (void)locationManager:(LocationManager *)manager didUpdateLocation:(CLLocation *)newLocation;
- (void)locationManager:(LocationManager *)manager didFailWithError:(NSError *)error;

@end
