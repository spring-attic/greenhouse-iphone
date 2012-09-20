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
//  GHVenueDetailsViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 10/4/10.
//

#import "GHVenueDetailsViewController.h"
#import "Venue.h"

@interface GHVenueDetailsViewController ()

@property (nonatomic, copy) NSString *html;

@end

@implementation GHVenueDetailsViewController

@synthesize html;
@synthesize venue;
@synthesize webView;
@synthesize buttonDirections;


#pragma -
#pragma Instance methods

- (IBAction)actionGetDirections:(id)sender
{
	NSString *encodedAddress = [venue.postalAddress stringByURLEncoding];
	NSString *urlString = [[NSString alloc] initWithFormat:@"http://maps.google.com/maps?q=%@", encodedAddress];
	NSURL *url = [NSURL URLWithString:urlString];	
	[[UIApplication sharedApplication] openURL:url];
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.title = @"Venue";
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"GHVenueDetailsContent" ofType:@"html"];
	self.html = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (venue)
	{
        NSString *contentHtml = [self.html copy];
        NSString *nameValue = venue.name != nil ? venue.name : @"";
        contentHtml = [contentHtml stringByReplacingOccurrencesOfString:@"{{NAME}}" withString:nameValue];
        NSString *addressValue = venue.postalAddress != nil ? venue.postalAddress : @"";
        contentHtml = [contentHtml stringByReplacingOccurrencesOfString:@"{{ADDRESS}}" withString:addressValue];
        NSString *descriptionValue = venue.locationHint != nil ? venue.locationHint : @"";
        contentHtml = [contentHtml stringByReplacingOccurrencesOfString:@"{{DESCRIPTION}}" withString:descriptionValue];
        [self.webView loadHTMLString:contentHtml baseURL:nil];
	}
}

- (void)viewDidUnload 
{
    [super viewDidUnload];

	self.html = nil;
    self.webView = nil;
	self.venue = nil;
	self.buttonDirections = nil;
}

@end
