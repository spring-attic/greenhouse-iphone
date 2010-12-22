//
//  DateHelperTest.m
//  Greenhouse
//
//  Created by Roy Clarkson on 12/21/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "DateHelper.h"


@interface DateHelperTest : GHTestCase {}
@end

@implementation DateHelperTest

// tests multiple days
- (void)testDaysBetweenStartTimeAndEndTime1
{
	// November 30, 2010, 17:00
	NSDate *startTime = [NSDate dateWithTimeIntervalSince1970:1291136400];
	
	// December 2, 2010, 15:00
	NSDate *endTime = [NSDate dateWithTimeIntervalSince1970:1291388400];
	
	NSArray *days = [DateHelper daysBetweenStartTime:startTime endTime:endTime];
	
	GHAssertNotNil(days, @"days should not be nil");
	GHAssertTrue([days count] == 4, @"there should be four days in the array");
}

// special case test spanning year and ending at midnight
- (void)testDaysBetweenStartTimeAndEndTime2
{
	// December 30, 2010, 22:00
	NSDate *startTime = [NSDate dateWithTimeIntervalSince1970:1293746400];
	
	// January 1, 2011, 00:00
	NSDate *endTime = [NSDate dateWithTimeIntervalSince1970:1293840000];
	
	NSArray *days = [DateHelper daysBetweenStartTime:startTime endTime:endTime];
	
	GHAssertNotNil(days, @"days should not be nil");
	GHAssertTrue([days count] == 2, @"there should be two days in the array");
}

// test single day
- (void)testDaysBetweenStartTimeAndEndTime3
{
	// July 10, 2010, 04:00
	NSDate *startTime = [NSDate dateWithTimeIntervalSince1970:1278734400];
	
	// July 10, 2010, 5:00
	NSDate *endTime = [NSDate dateWithTimeIntervalSince1970:1278738000];
	
	NSArray *days = [DateHelper daysBetweenStartTime:startTime endTime:endTime];
	
	GHAssertNotNil(days, @"days should not be nil");
	GHAssertTrue([days count] == 1, @"there should be one day in the array");
}

// negative test case start time is after end time
- (void)testDaysBetweenStartTimeAndEndTime4
{
	// April 1, 2010, 13:00
	NSDate *startTime = [NSDate dateWithTimeIntervalSince1970:1301662800];
	
	// March 30, 2010, 10:00
	NSDate *endTime = [NSDate dateWithTimeIntervalSince1970:1301479200];
	
	NSArray *days = [DateHelper daysBetweenStartTime:startTime endTime:endTime];
	
	GHAssertNotNil(days, @"days should not be nil");
	GHAssertTrue([days count] == 0, @"there should be no days in the array");
}


@end