//
//  EventMapViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/27/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Event.h"


@interface EventMapViewController : UIViewController <DataViewDelegate, MKMapViewDelegate>
{
	NSMutableData *receivedData;
}

@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) IBOutlet MKMapView *mapViewLocation;

- (void)refreshView;
- (void)fetchData;

@end
