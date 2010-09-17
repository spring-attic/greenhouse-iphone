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

- (void)fetchGeocodeResults;

@end


@implementation EventMapViewController

@synthesize eventAnnotation;
@synthesize event;
@synthesize mapViewLocation;

- (void)fetchGeocodeResults
{
	// See Google for details of the geocoding API
	// http://code.google.com/apis/maps/documentation/geocoding/#GeocodingRequests	
	
	NSString *urlString = [[NSString alloc] initWithFormat:EVENT_LOCATION_MAP_URL, event.location];
	NSString *escapedUrlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	[urlString release];
	
	DLog(@"%@", escapedUrlString);
	
	NSURL *url = [[NSURL alloc] initWithString:escapedUrlString];
	NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url
													 cachePolicy:NSURLRequestReturnCacheDataElseLoad
												 timeoutInterval:60.0];
	[url release];

	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
	[urlRequest release];
	
	if (connection) 
	{
		_receivedData = [[NSMutableData data] retain];
	} 
	else 
	{
		// Inform the user that the connection failed.
	}
}


#pragma mark -
#pragma mark NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [connection release];
    [_receivedData release];
	
    DLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	[connection release];
	
    DLog(@"Succeeded! Received %d bytes of data", [_receivedData length]);
	
	NSString *responseBody = [[NSString alloc] initWithData:_receivedData encoding:NSUTF8StringEncoding];
	[_receivedData release];
	
	NSDictionary *geocodeResponse = (NSDictionary *)[responseBody yajl_JSON];
	[responseBody release];
	
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
		
	MKCoordinateSpan span;
	span.latitudeDelta = 0.2f;
	span.longitudeDelta = 0.2f;
	
	MKCoordinateRegion region;
	region.span = span;
	region.center = coordinate;
	
	if (eventAnnotation != nil) 
	{
		[mapViewLocation removeAnnotation:eventAnnotation];
		[eventAnnotation release];
	}
	
	self.eventAnnotation = [[EventAnnotation alloc] init];
	eventAnnotation.coordinate = coordinate;
	
	[mapViewLocation addAnnotation:eventAnnotation];
	[mapViewLocation setRegion:region animated:YES];
	[mapViewLocation regionThatFits:region];
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
#pragma mark DataViewController methods

- (void)reloadData
{
	[self fetchGeocodeResults];
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.title = @"Map";
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
