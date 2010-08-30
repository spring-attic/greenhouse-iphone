//
//  LocationManager.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/27/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "LocationManager.h"


@interface LocationManager()

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *bestEffortLocation;

@end


@implementation LocationManager

@synthesize locationManager;
@synthesize bestEffortLocation;
@synthesize delegate;


#pragma mark -
#pragma mark Static methods

+ (LocationManager *)locationManager
{
	return [[[LocationManager alloc] init] autorelease];
}


#pragma mark -
#pragma mark Instance methods

- (void)startUpdatingLocation
{
	if (!_locating)
	{
		self.locationManager = [[[CLLocationManager alloc] init] autorelease];
		locationManager.delegate = self;
		locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
		[locationManager startUpdatingLocation];
		_locating = YES;
		
		// create a timer to stop the locationManager after 45 seconds
		[self performSelector:@selector(stopUpdatingLocation) withObject:nil afterDelay:45.0];
	}
}

- (void)stopUpdatingLocation
{
	[locationManager stopUpdatingLocation];
	locationManager.delegate = nil;
	_locating = NO;
}


#pragma mark -
#pragma mark CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation 
{
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
	
	// make sure we aren't using an old, cached location
    if (locationAge > 10.0)
	{
		return;
	}
	
    // a negative horizontal accuracy means the location is invalid
    if (newLocation.horizontalAccuracy < 0)
	{
		return;
	}
	
    // test the measurement to see if it is more accurate than the previous measurement
    if (bestEffortLocation == nil || bestEffortLocation.horizontalAccuracy > newLocation.horizontalAccuracy) 
	{
        self.bestEffortLocation = newLocation;
		
		// stop locating once we get a fix that meets our accuracy requirements
        if (newLocation.horizontalAccuracy <= locationManager.desiredAccuracy) 
		{
			[self stopUpdatingLocation];
			
            // we can also cancel our previous performSelector:withObject:afterDelay: - it's no longer necessary
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopUpdatingLocation) object:nil];
			
			// pass the new location back to the delegate
			[delegate locationManager:self didUpdateLocation:newLocation];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error 
{
    if ([error code] != kCLErrorLocationUnknown) 
	{
		[self stopUpdatingLocation];
		
		[delegate locationManager:self didFailWithError:error];
    }
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc
{
	[locationManager stopUpdatingLocation];
	self.locationManager = nil;
	self.bestEffortLocation = nil;
	
	[super dealloc];
}

@end
