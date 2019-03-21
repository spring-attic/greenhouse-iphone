//
//  Copyright 2012 the original author or authors.
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
//  NSDictionary_HelpersTests.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/13/12.
//

#import "NSDictionary_HelpersTests.h"

#define KEY_STRING              @"string"
#define KEY_INTEGER             @"integer"
#define KEY_INTEGER_AS_STRING   @"integerAsString"
#define KEY_FLOAT               @"float"
#define KEY_BOOL_YES_AS_STRING  @"boolYesAsString"
#define KEY_BOOL_YES_AS_NUMBER  @"boolYesAsNumber"
#define KEY_BOOL_NO_AS_STRING   @"boolNoAsString"
#define KEY_BOOL_NO_AS_NUMBER   @"boolNoAsNumber"
#define KEY_NULL                @"null"
#define KEY_NOT_FOUND           @"notFound"

@interface NSDictionary_HelpersTests()

@property (nonatomic, strong) NSDictionary *testData;

@end

@implementation NSDictionary_HelpersTests

@synthesize testData;

- (void)setUp
{
    [super setUp];

    self.testData = [[NSDictionary alloc] initWithObjectsAndKeys:
                     @"testing123", KEY_STRING,
                     [NSNumber numberWithInt:1001], KEY_INTEGER,
                     @"1299", KEY_INTEGER_AS_STRING,
                     [NSNumber numberWithFloat:1.123f] , KEY_FLOAT,
                     @"YES", KEY_BOOL_YES_AS_STRING,
                     [NSNumber numberWithBool:YES], KEY_BOOL_YES_AS_NUMBER,
                     @"NO", KEY_BOOL_NO_AS_STRING,
                     [NSNumber numberWithBool:NO], KEY_BOOL_NO_AS_NUMBER,
                     [NSNull null], @"null",
                     nil];
}

- (void)tearDown
{
    self.testData = nil;

    [super tearDown];
}

#pragma mark -
#pragma mark stringForKey tests

- (void)testStringForKey
{
    NSString *expected = @"testing123";
    NSString *actual = [testData stringForKey:KEY_STRING];
    STAssertEqualObjects(expected, actual, @"strings are not equal");
}

- (void)testStringForKeyInteger
{
    NSString *expected = @"1001";
    NSString *actual = [testData stringForKey:KEY_INTEGER];
    STAssertEqualObjects(expected, actual, @"strings are not equal");
}

- (void)testStringForKeyFloat
{
    NSString *expected = @"1.123";
    NSString *actual = [testData stringForKey:KEY_FLOAT];
    STAssertEqualObjects(expected, actual, @"strings are not equal");
}

- (void)testStringForKeyNil
{
    NSString *actual = [testData stringForKey:KEY_NULL];
    STAssertNil(actual, @"should be nil");
}

- (void)testStringForKeyNotFound
{
    NSString *s = [testData stringForKey:KEY_NOT_FOUND];
    STAssertNil(s, @"should be nil");
}


#pragma mark -
#pragma mark stringByReplacingPercentEscapesForKey tests

// TODO: ADD TESTS


#pragma mark -
#pragma mark integerForKey tests

- (void)testIntegerForKey
{
    NSInteger expected = 1001;
    NSInteger actual = [testData integerForKey:KEY_INTEGER];
    STAssertEquals(expected, actual, @"values are not equal");
}

// can't convert an alpha-numeric string to an integer
- (void)testIntegerForKeyString
{
    NSInteger expected = 0;
    NSInteger actual = [testData integerForKey:KEY_STRING];
    STAssertEquals(expected, actual, @"should be 0");
}

// if an integer is stored as a string, then it is converted
- (void)testIntegerForKeyIntegerAsString
{
    NSInteger expected = 1299;
    NSInteger actual = [testData integerForKey:KEY_INTEGER_AS_STRING];
    STAssertEquals(expected, actual, @"values are not equal");
}

// floats are reduced to integers, truncating the decimal value
- (void)testIntegerForKeyFloat
{
    NSInteger expected = 1;
    NSInteger actual = [testData integerForKey:KEY_FLOAT];
    STAssertEquals(expected, actual, @"values are not equal");
}

// if the value for a key is nil, then zero is returned
- (void)testIntegerForKeyNil
{
    NSInteger expected = 0;
    NSInteger actual = [testData integerForKey:KEY_NULL];
    STAssertEquals(expected, actual, @"values are not equal");
}

- (void)testIntegerForKeyNotFound
{
    NSInteger expected = 0;
    NSInteger actual = [testData integerForKey:KEY_NOT_FOUND];
    STAssertEquals(expected, actual, @"values are not equal");
}


#pragma mark -
#pragma mark doubleForKey tests

- (void)testDoubleForKey
{
    double expected = 1.123f;
    double actual = [testData doubleForKey:KEY_FLOAT];
    STAssertEquals(expected, actual, @"values are not equal");
}

- (void)testDoubleForKeyString
{
    double expected = 0.0f;
    double actual = [testData doubleForKey:KEY_STRING];
    STAssertEquals(expected, actual, @"values are not equal");
}

- (void)testDoubleForKeyInteger
{
    double expected = 1001;
    double actual = [testData doubleForKey:KEY_INTEGER];
    STAssertEquals(expected, actual, @"values are not equal");
}

- (void)testDoubleForKeyNil
{
    double expected = 0.0f;
    double actual = [testData doubleForKey:KEY_NULL];
    STAssertEquals(expected, actual, @"values are not equal");
}

- (void)testDoubleForKeyNotFound
{
    double expected = 0.0f;
    double actual = [testData doubleForKey:KEY_NOT_FOUND];
    STAssertEquals(expected, actual, @"values are not equal");
}


#pragma mark -
#pragma mark boolForKey tests

- (void)testBoolForKeyYesAsString
{
    BOOL expected = YES;
    BOOL actual = [testData boolForKey:KEY_BOOL_YES_AS_STRING];
    STAssertEquals(expected, actual, @"values are not equal");
}

- (void)testBoolForKeyNoAsString
{
    BOOL expected = NO;
    BOOL actual = [testData boolForKey:KEY_BOOL_NO_AS_STRING];
    STAssertEquals(expected, actual, @"values are not equal");
}

- (void)testBoolForKeyYesAsNumber
{
    BOOL expected = YES;
    BOOL actual = [testData boolForKey:KEY_BOOL_YES_AS_NUMBER];
    STAssertEquals(expected, actual, @"values are not equal");
}

- (void)testBoolForKeyNoAsNumber
{
    BOOL expected = NO;
    BOOL actual = [testData boolForKey:KEY_BOOL_NO_AS_NUMBER];
    STAssertEquals(expected, actual, @"values are not equal");
}

// non zero values are interpretted as true
- (void)testBoolForKeyString
{
    BOOL expected = YES;
    BOOL actual = [testData boolForKey:KEY_STRING];
    STAssertEquals(expected, actual, @"values are not equal");
}

// non zero values are interpretted as true
- (void)testBoolForKeyInteger
{
    BOOL expected = YES;
    BOOL actual = [testData boolForKey:KEY_INTEGER];
    STAssertEquals(expected, actual, @"values are not equal");
}

// non zero values are interpretted as true
- (void)testBoolForKeyIntegerAsString
{
    BOOL expected = YES;
    BOOL actual = [testData boolForKey:KEY_INTEGER_AS_STRING];
    STAssertEquals(expected, actual, @"values are not equal");
}

// non zero values are interpretted as true
- (void)testBoolForKeyDouble
{
    BOOL expected = YES;
    BOOL actual = [testData boolForKey:KEY_FLOAT];
    STAssertEquals(expected, actual, @"values are not equal");
}

- (void)testBoolForKeyNil
{
    BOOL expected = NO;
    BOOL actual = [testData boolForKey:KEY_NULL];
    STAssertEquals(expected, actual, @"values are not equal");
}

- (void)testBoolForKeyNotFound
{
    BOOL expected = NO;
    BOOL actual = [testData boolForKey:KEY_NOT_FOUND];
    STAssertEquals(expected, actual, @"values are not equal");
}


#pragma mark -
#pragma mark dateWithMillisecondsSince1970ForKey tests

// TODO: ADD TESTS


#pragma mark -
#pragma mark urlForKey tests

// TODO: ADD TESTS







@end
