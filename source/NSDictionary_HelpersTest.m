//
//  NSDictionary_HelpersTest.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/14/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "NSDictionary_HelpersTest.h"

#define stringValue @"test string"
#define stringKey @"stringKey"
#define integerValue 34
#define integerKey @"integerKey"
#define doubleValue 999.1234f
#define doubleKey @"doubleKey"
#define millisecondsValue 1274015177470
#define millisecondsKey @"dateKey"


@implementation NSDictionary_HelpersTest

- (void)setUp
{
		dictionary = [[[NSDictionary alloc] initWithObjectsAndKeys:
					   stringValue, stringKey, 
					   [NSNumber numberWithInteger:integerValue], integerKey, 
					   [NSNumber numberWithDouble:doubleValue], doubleKey, 
					   [NSNumber numberWithDouble:millisecondsValue], millisecondsKey, 
					   nil] retain];
}

- (void)tearDown
{
	[dictionary release];
}


- (void) testStringForKey 
{	
	NSString *s = [dictionary stringForKey:stringKey];
	
	
	STAssertNotNil(s, @"String should not be nil");
	
    STAssertTrue([s isEqualToString:stringValue], @"Strings should be equal" );
}

- (void)testIntegerForKey
{
	NSInteger i = [dictionary integerForKey:integerKey];
	
	STAssertTrue(i == integerValue, [NSString stringWithFormat:@"Integer should equal %i", integerValue]);
}

- (void)testDoubleForKey
{
	double d = [dictionary doubleForKey:doubleKey];
	
	STAssertTrue(d == doubleValue, [NSString stringWithFormat:@"Double should equal %f", doubleValue]);
}

- (void)testdateWithMillisecondsSince1970ForKey
{
	NSDate *date = [dictionary dateWithMillisecondsSince1970ForKey:millisecondsKey];
	
	NSTimeInterval unixDate = (millisecondsValue *.001);
	STAssertTrue(date.timeIntervalSince1970 == unixDate, @"Date intervals do not match");
}

@end
