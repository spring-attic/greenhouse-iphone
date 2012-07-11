//
//  DateHelper.m
//  Greenhouse
//
//  Created by Roy Clarkson on 12/21/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
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
