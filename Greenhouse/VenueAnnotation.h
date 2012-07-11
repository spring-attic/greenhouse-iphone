//
//  VenueAnnotation.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/27/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@class Venue;


@interface VenueAnnotation : NSObject <MKAnnotation> 
{

@private
	Venue *_venue;
	CLLocationCoordinate2D _coordinate;
}

@property (nonatomic, retain) Venue *venue;

- (id)initWithVenue:(Venue *)venue;

@end
