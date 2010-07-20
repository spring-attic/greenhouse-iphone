//
//  NSDictionary_HelpersTest.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/14/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//
//  See Also: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html

#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import "NSDictionary+Helpers.h"


@interface NSDictionary_HelpersTest : SenTestCase 
{
	NSDictionary *dictionary;
}

- (void)testStringForKey;
- (void)testIntegerForKey;
- (void)testDoubleForKey;
- (void)testdateWithMillisecondsSince1970ForKey;

@end
