//
//  Copyright 2010-2012 the original author or authors.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//
//  GHInfoViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 9/14/10.
//

#import "GHInfoViewController.h"


@implementation GHInfoViewController

@synthesize webView;

#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"GHInfoContent" ofType:@"html"];
	NSString *htmlString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
	[self.webView loadHTMLString:htmlString baseURL:nil];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.webView = nil;
}

@end
