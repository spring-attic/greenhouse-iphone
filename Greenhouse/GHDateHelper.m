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
//  GHDateHelper.m
//  Greenhouse
//
//  Created by Roy Clarkson on 12/21/10.
//

#import "GHDateHelper.h"


@implementation GHDateHelper

+ (NSArray *)daysBetweenStartTime:(NSDate *)startTime endTime:(NSDate *)endTime
{
	DLog(@"startTime: %@", [startTime description]);
	DLog(@"endTime: %@", [endTime description]);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *fromDate;
    NSDate *toDate;
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate interval:NULL forDate:startTime];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate interval:NULL forDate:endTime];
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate
                                                 toDate:toDate
                                                options:0];
    NSUInteger days = [difference day] + 1;
    
    DLog(@"fromDate: %@", fromDate);
    DLog(@"toDate: %@", toDate);

	NSMutableArray *arrayDays = [[NSMutableArray alloc] init];
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    NSDate *eventDate;
    for (int i = 0; i < days; i++)
    {
        [dayComponent setDay:i];
        
		// calculate the next event day
		eventDate = [calendar dateByAddingComponents:dayComponent toDate:fromDate options:0];
		DLog(@"event day: %@", [eventDate description]);
        
        // add the next day to the array of days
		[arrayDays addObject:eventDate];
    }
    
    return arrayDays;
}

@end
