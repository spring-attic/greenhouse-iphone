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
//  DateHelper.m
//  Greenhouse
//
//  Created by Roy Clarkson on 12/21/10.
//

#import "DateHelper.h"


@implementation DateHelper

+ (NSArray *)daysBetweenStartTime:(NSDate *)startTime endTime:(NSDate *)endTime
{
	NSMutableArray *arrayDays = [NSMutableArray array];
	
	DLog(@"startTime: %@", [startTime description]);
	DLog(@"endTime: %@", [endTime description]);
	
	// create a mask to remove the time component, leaving just the date
	NSUInteger flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
	NSCalendar *calendar = [NSCalendar currentCalendar];
	
	// remove the time from the start date
	NSDateComponents *components = [calendar components:flags fromDate:startTime];
	NSDate *eventDate = [calendar dateFromComponents:components];
	
	// remove the time from the end date
	components = [calendar components:flags fromDate:endTime];
	NSDate *endDate = [calendar dateFromComponents:components];
	
	DLog(@"first day: %@", [eventDate description]);
	DLog(@"last day: %@", [endDate description]);
	
	// continue adding 24 hrs to the start date until we reach the last day
	while ([eventDate compare:endDate] != NSOrderedDescending)
	{
		// add the next day to the array of days
		[arrayDays addObject:eventDate];
		
		// calculate the next event day by adding 24 hours
		eventDate = [eventDate dateByAddingTimeInterval:86400];
		DLog(@"event day: %@", [eventDate description]);
	}
	
	return arrayDays;	
}

@end
