//
//  LocationManager.h
//  Greenhouse
//
//  Created by Roy Clarkson on 8/27/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationManagerDelegate.h"


@interface LocationManager : NSObject <CLLocationManagerDelegate> 
{ 
	id<LocationManagerDelegate> _delegate;
	CLLocationManager *_locationManager;
	CLLocation *_bestEffortLocation;
	BOOL _locating;
}

@property (nonatomic, assign) id<LocationManagerDelegate> delegate;
@property (nonatomic, retain) CLLocationManager *locationManager;

+ (LocationManager *)locationManager;
- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

@end
