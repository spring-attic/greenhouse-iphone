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
//  GHLocationManager.h
//  Greenhouse
//
//  Created by Roy Clarkson on 8/27/10.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "GHLocationManagerDelegate.h"


@interface GHLocationManager : NSObject <CLLocationManagerDelegate> 
{ 
	CLLocationManager *_locationManager;
	CLLocation *_bestEffortLocation;
	BOOL _locating;
}

@property (nonatomic, unsafe_unretained) id<GHLocationManagerDelegate> delegate;
@property (nonatomic, strong) CLLocationManager *locationManager;

+ (GHLocationManager *)locationManager;
- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

@end
