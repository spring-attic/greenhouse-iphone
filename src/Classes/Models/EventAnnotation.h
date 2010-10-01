//
//  EventAnnotation.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/27/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Event.h"


@interface EventAnnotation : NSObject <MKAnnotation> 
{

@private
	CLLocationCoordinate2D coordinate;
}

@property (nonatomic, retain) Event *event;

@end
