    //
//  InfoViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 9/14/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "InfoViewController.h"


@implementation InfoViewController

@synthesize webView;

#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"InfoContent" ofType:@"html"];
	NSString *htmlString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
	[self.webView loadHTMLString:htmlString baseURL:nil];
	[htmlString release];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.webView = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[webView release];
	
    [super dealloc];
}


@end
