//
//  Copyright 2012 the original author or authors.
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
//  UIColor_CustomColorsTests.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/10/12.
//

#import "UIColor_CustomColorsTests.h"

@interface UIColor_CustomColorsTests()

- (UIColor *)colorFromHexString:(NSString *)hexString;

@end

@implementation UIColor_CustomColorsTests

- (void)testSpringDarkGreenColor
{
    UIColor *expected = [self colorFromHexString:@"#387C2C"];
    UIColor *actual = [UIColor springDarkGreenColor];
    STAssertEqualObjects(expected, actual, @"colors are not equal");
}

- (void)testSpringLightGreenColor
{
    UIColor *expected = [self colorFromHexString:@"#6DB33F"];
    UIColor *actual = [UIColor springLightGreenColor];
    STAssertEqualObjects(expected, actual, @"colors are not equal");
}


#pragma mark -
#pragma mark Helpers

// As answered by Dave DeLong in the following StackOverflow question
// https://stackoverflow.com/questions/3805177/how-to-convert-hex-rgb-color-codes-to-uicolor
- (UIColor *)colorFromHexString:(NSString *)hexString
{
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }

    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];

    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;

    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
