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
//  GHLocationManager.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/27/10.
//

#import "GHLocationManager.h"


@implementation GHLocationManager

@synthesize delegate;
@synthesize locationManager = _locationManager;


#pragma mark -
#pragma mark Static methods

+ (GHLocationManager *)locationManager
{
	return [[GHLocationManager alloc] init];
}


#pragma mark -
#pragma mark Instance methods

- (void)startUpdatingLocation
{
	if (!_locating)
	{
		self.locationManager = [[CLLocationManager alloc] init];
		_locationManager.delegate = self;
		_locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
		[_locationManager startUpdatingLocation];
		_locating = YES;
		
		// create a timer to stop the locationManager after 45 seconds
		[self performSelector:@selector(stopUpdatingLocation) withObject:nil afterDelay:45.0];
	}
}

- (void)stopUpdatingLocation
{
	_locating = NO;
	
	if (_locationManager)
	{
		[_locationManager stopUpdatingLocation];
		_locationManager.delegate = nil;
	}
}


#pragma mark -
#pragma mark CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation 
{
	DLog(@"");
	
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
    if (_bestEffortLocation == nil || _bestEffortLocation.horizontalAccuracy > newLocation.horizontalAccuracy) 
	{
		DLog(@"updated bestEfforLocation");
		
        _bestEffortLocation = newLocation;
		
		// stop locating once we get a fix that meets our accuracy requirements
        if (newLocation.horizontalAccuracy <= _locationManager.desiredAccuracy) 
		{
			DLog(@"found good accuracy");
			
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
		DLog(@"%@", [error localizedDescription]);
		
		[self stopUpdatingLocation];
		
		[delegate locationManager:self didFailWithError:error];
    }
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc
{
	[self stopUpdatingLocation];
	_bestEffortLocation = nil;
}

@end
