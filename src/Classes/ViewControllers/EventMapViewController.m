    //
//  EventMapViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/27/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "EventMapViewController.h"
#import "Event.h"
#import "Venue.h"
#import "VenueAnnotation.h"


@interface EventMapViewController()

@property (nonatomic, retain) NSMutableArray *venueAnnotations;

@end


@implementation EventMapViewController

@synthesize venueAnnotations;
@synthesize event;
@synthesize mapViewLocation;
@synthesize venueDetailsViewController;


#pragma mark -
#pragma mark MKMapViewDelegate methods

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	static NSString *ident = @"annotation";
	
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ident];
	
	if (annotationView == nil)
	{
		annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ident] autorelease];
		annotationView.pinColor = MKPinAnnotationColorGreen;
		annotationView.animatesDrop = YES;
		annotationView.canShowCallout = YES;
		annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];		
	}
		
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	VenueAnnotation *venueAnnotation = (VenueAnnotation *)view.annotation;
	venueDetailsViewController.venue = venueAnnotation.venue;
	[self.navigationController pushViewController:venueDetailsViewController animated:YES];
}


#pragma mark -
#pragma mark DataViewController methods

- (void)reloadData
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
	
	for (Venue *venue in event.venues)
	{
		VenueAnnotation *annotation = [[VenueAnnotation alloc] initWithVenue:venue];
		[self.venueAnnotations addObject:annotation];
		[annotation release];
		
		// find the max and min lat,lng values to determine the bounds of the map
		CLLocationDegrees lat = venue.location.coordinate.latitude;
		CLLocationDegrees lng = venue.location.coordinate.longitude;
		
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
		VenueAnnotation *annotation = [venueAnnotations objectAtIndex:0];
		
		span.latitudeDelta = 0.2f;
		span.longitudeDelta = 0.2f;
		
		center = annotation.coordinate;
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
	}
	
	MKCoordinateRegion region;
	region.span = span;
	region.center = center;	
	
	[mapViewLocation addAnnotations:venueAnnotations];
	[mapViewLocation setRegion:region animated:YES];
	[mapViewLocation regionThatFits:region];	
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.title = @"Map";
	
	self.venueAnnotations = [[NSMutableArray alloc] init];
	self.venueDetailsViewController = [[VenueDetailsViewController alloc] initWithNibName:nil bundle:nil];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.venueAnnotations = nil;
	self.event = nil;
	self.mapViewLocation = nil;
	self.venueDetailsViewController = nil;
}


- (void)dealloc 
{
	[venueAnnotations release];
	[event release];
	[mapViewLocation release];
	[venueDetailsViewController release];
	
    [super dealloc];
}


@end
