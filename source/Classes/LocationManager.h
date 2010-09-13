//
//  LocationManager.h
//  Greenhouse
//
//  Created by Roy Clarkson on 8/27/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@class LocationManager;


@protocol LocationManagerDelegate

- (void)locationManager:(LocationManager *)manager didUpdateLocation:(CLLocation *)newLocation;
- (void)locationManager:(LocationManager *)manager didFailWithError:(NSError *)error;

@end


@interface LocationManager : NSObject <CLLocationManagerDelegate> 
{ 
	BOOL _locating;
}

@property (nonatomic, assign) id<LocationManagerDelegate> delegate;

+ (LocationManager *)locationManager;

- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

@end
