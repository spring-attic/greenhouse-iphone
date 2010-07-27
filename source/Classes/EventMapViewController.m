    //
//  EventMapViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/27/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "EventMapViewController.h"
#import "EventAnnotation.h"


@interface EventMapViewController()

@property (nonatomic, retain) EventAnnotation *eventAnnotation;

- (CLLocationCoordinate2D)eventCoordinate;

@end


@implementation EventMapViewController

@synthesize eventAnnotation;
@synthesize event;
@synthesize mapViewLocation;


- (CLLocationCoordinate2D)eventCoordinate;
{
	// See Google for details of the geocoding API
	// http://code.google.com/apis/maps/documentation/geocoding/#GeocodingRequests

    NSString *urlString = [[NSString alloc] initWithFormat:@"http://maps.google.com/maps/api/geocode/json?address=Chicago,+IL&sensor=true", event.location];
	NSString *escapedUrlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	[urlString release];
	
	DLog(@"%@", escapedUrlString);
	
	NSURL *url = [[NSURL alloc] initWithString:escapedUrlString];
    NSString *responsBody = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
	[url release];
	
	DLog(@"%@", responsBody);
	
	NSDictionary *geocodeResponse = (NSDictionary *)[responsBody JSONValue];
	
	NSString *status = [geocodeResponse stringForKey:@"status"];
	NSArray *results = (NSArray *)[geocodeResponse objectForKey:@"results"];
	
    double latitude = 0.0f;
    double longitude = 0.0f;
	
	if ([status isEqualToString:@"OK"])
	{		
		NSArray *a = [results valueForKey:@"geometry"];
		NSDictionary *geometry = (NSDictionary *)[a objectAtIndex:0];
		
		if (geometry)
		{
			NSDictionary *location = (NSDictionary *)[geometry objectForKey:@"location"];
			
			latitude = [location doubleForKey:@"lat"];
			longitude = [location doubleForKey:@"lng"];
		}
	}
		
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = latitude;
    coordinate.longitude = longitude;
	
    return coordinate;
}


#pragma mark -
#pragma mark MKMapViewDelegate methods

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	static NSString *ident = @"annotation";
	
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ident];
	
	if (annotationView == nil)
	{
		annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ident] autorelease];
	}
	
    annotationView.pinColor = MKPinAnnotationColorGreen;
    annotationView.animatesDrop = YES;
    annotationView.canShowCallout = NO;
    annotationView.calloutOffset = CGPointMake(-5.0f, 5.0f);
	
    return annotationView;
}

#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.title = @"Map";
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta = 0.2f;
	span.longitudeDelta = 0.2f;
	
	CLLocationCoordinate2D coordinate = [self eventCoordinate];
	region.span = span;
	region.center = coordinate;
	
	if(eventAnnotation != nil) 
	{
		[mapViewLocation removeAnnotation:eventAnnotation];
		self.eventAnnotation = nil;
	}
	
	self.eventAnnotation = [[EventAnnotation alloc] init];
	eventAnnotation.coordinate = coordinate;
	
	[mapViewLocation addAnnotation:eventAnnotation];
	[mapViewLocation setRegion:region animated:YES];
	[mapViewLocation regionThatFits:region];	
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.eventAnnotation = nil;
	self.event = nil;
	self.mapViewLocation = nil;
}


- (void)dealloc 
{
	[eventAnnotation release];
	[event release];
	[mapViewLocation release];
	
    [super dealloc];
}


@end
