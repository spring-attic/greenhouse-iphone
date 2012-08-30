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
//  GHBaseController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 9/16/10.
//

#import <Foundation/Foundation.h>
#import "GHAuthorizedRequest.h"
#import "OA2AccessGrant.h"
#import "GHActivityAlertView.h"


@interface GHBaseController : NSObject
{
	GHActivityAlertView *_activityAlertView;
	id _didFailDelegate;
	SEL _didFailSelector;
	NSError *_error;
}

@property (nonatomic, strong) GHActivityAlertView *activityAlertView;

- (void)requestDidNotSucceedWithDefaultMessage:(NSString *)message response:(NSURLResponse *)response;
- (void)requestDidFailWithError:(NSError *)error;

@end
