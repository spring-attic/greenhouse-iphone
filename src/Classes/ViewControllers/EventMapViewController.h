//
//  EventMapViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/27/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "VenueDetailsViewController.h"


@class Event;

@interface EventMapViewController : DataViewController <MKMapViewDelegate>
{
	NSMutableData *_receivedData;
}

@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) IBOutlet MKMapView *mapViewLocation;
@property (nonatomic, retain) VenueDetailsViewController *venueDetailsViewController;

@end
