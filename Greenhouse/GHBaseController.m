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
//  GHBaseController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 9/16/10.
//

#import "GHBaseController.h"

@implementation GHBaseController

@synthesize activityAlertView = _activityAlertView;

- (void)requestDidNotSucceedWithDefaultMessage:(NSString *)message response:(NSURLResponse *)response
{
	NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
	DLog(@"status code: %d", statusCode);
	
	if (statusCode == 401)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
														message:@"You are not authorized to view the content from greenhouse.springsource.com. Please sign out and reauthorize the Greenhouse app." 
													   delegate:appDelegate 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:@"Sign Out", nil];
		[alert show];
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
														message:message 
													   delegate:nil 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
	}
}

- (void)requestDidFailWithError:(NSError *)error
{	
	DLog(@"%@", [error localizedDescription]);
	
	if ([error code] == NSURLErrorUserCancelledAuthentication)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
														message:@"You are not authorized to view the content from greenhouse.springsource.com. Please sign out and reauthorize the Greenhouse app." 
													   delegate:appDelegate 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:@"Sign Out", nil];
		[alert show];
	}
	else 
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
														message:@"The network connection is not available. Please try again in a few minutes." 
													   delegate:nil 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
	}	
}

@end
