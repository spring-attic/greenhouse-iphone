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
//  GHEventMapViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/27/10.
//

#import "GHEventMapViewController.h"
#import "GHVenueDetailsViewController.h"
#import "GHEventController.h"
#import "Event.h"
#import "Venue.h"
#import "GHVenueAnnotation.h"

@interface GHEventMapViewController ()

@property (nonatomic, strong) Event *currentEvent;
@property (nonatomic, strong) NSMutableArray *venueAnnotations;

- (void)reloadMapData;

@end

@implementation GHEventMapViewController

@synthesize venueAnnotations;
@synthesize currentEvent;
@synthesize mapViewLocation;
@synthesize venueDetailsViewController;


#pragma mark -
#pragma mark Private methods

- (void)reloadMapData
{
	if (venueAnnotations != nil)
	{
		[mapViewLocation removeAnnotations:venueAnnotations];
		[venueAnnotations removeAllObjects];
	}
	
	CLLocationDegrees maxLat = 0.0f;
	CLLocationDegrees minLat = 0.0f;
	CLLocationDegrees maxLng = 0.0f;
	CLLocationDegrees minLng = 0.0f;	
	
	for (Venue *venue in currentEvent.venues)
	{
		GHVenueAnnotation *annotation = [[GHVenueAnnotation alloc] initWithVenue:venue];
		[self.venueAnnotations addObject:annotation];
		
		// find the max and min lat,lng values to determine the bounds of the map
		CLLocationDegrees lat = [venue.latitude doubleValue];
		CLLocationDegrees lng = [venue.longitude doubleValue];
		
		if (lat != 0 && lat > maxLat)
		{
			maxLat = lat;
		}
		
		if (lat != 0 && lat < minLat)
		{
			minLat = lat;
		}
		
		if (lng != 0 && lng > maxLng)
		{
			maxLng = lng;
		}
		
		if (lng != 0 && lng < minLng)
		{
			minLng = lng;
		}
	}
	
	if ([venueAnnotations count] == 0)
	{
		return;
	}
	
	MKCoordinateSpan span;
	CLLocationCoordinate2D center;
	
	if ([venueAnnotations count] == 1)
	{
		// if we only have a single venue location, then no need to calculate the map bounds
		GHVenueAnnotation *annotation = [venueAnnotations objectAtIndex:0];
		
		span.latitudeDelta = 0.2f;
		span.longitudeDelta = 0.2f;
		
		center = annotation.coordinate;
		
		MKCoordinateRegion region;
		region.span = span;
		region.center = center;
		
		[mapViewLocation addAnnotations:venueAnnotations];
		[mapViewLocation setRegion:region animated:YES];
		[mapViewLocation regionThatFits:region];		
	}
	else if ([venueAnnotations count] > 1)
	{
		// set the map bounds based on the furthest two locations
		CLLocationDegrees latDelta = maxLat - minLat;
		CLLocationDegrees lngDelta = maxLng - minLng;
		
		span.latitudeDelta = latDelta;
		span.longitudeDelta = lngDelta;
		
		center.latitude = latDelta / 2;
		center.longitude = lngDelta / 2;

		MKCoordinateRegion region;
		region.span = span;
		region.center = center;	
		
		[mapViewLocation addAnnotations:venueAnnotations];
		[mapViewLocation setRegion:region animated:YES];
		[mapViewLocation regionThatFits:region];		
	}	
}


#pragma mark -
#pragma mark MKMapViewDelegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    DLog(@"");
	static NSString *ident = @"annotation";
	
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ident];
	
	if (annotationView == nil)
	{
		annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ident];
		annotationView.pinColor = MKPinAnnotationColorGreen;
		annotationView.animatesDrop = YES;
		annotationView.canShowCallout = YES;
		annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];		
	}
		
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    DLog(@"");
	GHVenueAnnotation *venueAnnotation = (GHVenueAnnotation *)view.annotation;
	venueDetailsViewController.venue = venueAnnotation.venue;
	[self.navigationController pushViewController:venueDetailsViewController animated:YES];
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
    DLog(@"");
	
	self.title = @"Map";
	self.venueAnnotations = [[NSMutableArray alloc] init];
	self.venueDetailsViewController = [[GHVenueDetailsViewController alloc] initWithNibName:nil bundle:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DLog(@"");
    
    Event *event = [[GHEventController sharedInstance] fetchSelectedEvent];
    if (event == nil)
    {
        DLog(@"selected event not available");
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    else if (currentEvent == nil || ![currentEvent.eventId isEqualToNumber:event.eventId])
	{
		self.currentEvent = event;
		[self reloadMapData];
	}
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	DLog(@"");
    
	self.venueAnnotations = nil;
	self.currentEvent = nil;
	self.mapViewLocation = nil;
	self.venueDetailsViewController = nil;
}

@end
