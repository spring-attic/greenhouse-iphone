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
//  NSString+XmlEncoding.m
//  Greenhouse
//
//  Created by Roy Clarkson on 9/23/10.
//
//  Code and solution discussed at http://stackoverflow.com/questions/803676/encode-nsstring-for-xml-html/1933237
//

#import "NSString+XmlEncoding.h"


@implementation NSString (NSString_XmlEncoding)

- (NSString *)stringBySimpleXmlEncoding
{
	NSMutableString *string = [NSMutableString stringWithString:self];
	
	[string replaceOccurrencesOfString:@"&"  withString:@"&amp;"  options:NSLiteralSearch range:NSMakeRange(0, [string length])];
    [string replaceOccurrencesOfString:@"\"" withString:@"&quot;" options:NSLiteralSearch range:NSMakeRange(0, [string length])];
    [string replaceOccurrencesOfString:@"'"  withString:@"&#x27;" options:NSLiteralSearch range:NSMakeRange(0, [string length])];
    [string replaceOccurrencesOfString:@">"  withString:@"&gt;"   options:NSLiteralSearch range:NSMakeRange(0, [string length])];
    [string replaceOccurrencesOfString:@"<"  withString:@"&lt;"   options:NSLiteralSearch range:NSMakeRange(0, [string length])];
	
    return string;
}

- (NSString *)stringBySimpleXmlDecoding
{
	NSMutableString *string = [NSMutableString stringWithString:self];
	
	[string replaceOccurrencesOfString:@"&amp;"  withString:@"&"  options:NSLiteralSearch range:NSMakeRange(0, [string length])];
    [string replaceOccurrencesOfString:@"&quot;" withString:@"\"" options:NSLiteralSearch range:NSMakeRange(0, [string length])];
    [string replaceOccurrencesOfString:@"&#x27;" withString:@"'"  options:NSLiteralSearch range:NSMakeRange(0, [string length])];
    [string replaceOccurrencesOfString:@"&#x39;" withString:@"'"  options:NSLiteralSearch range:NSMakeRange(0, [string length])];
    [string replaceOccurrencesOfString:@"&#x92;" withString:@"'"  options:NSLiteralSearch range:NSMakeRange(0, [string length])];
    [string replaceOccurrencesOfString:@"&#x96;" withString:@"'"  options:NSLiteralSearch range:NSMakeRange(0, [string length])];
    [string replaceOccurrencesOfString:@"&gt;"   withString:@">"  options:NSLiteralSearch range:NSMakeRange(0, [string length])];
    [string replaceOccurrencesOfString:@"&lt;"   withString:@"<"  options:NSLiteralSearch range:NSMakeRange(0, [string length])];
	
    return string;
}

@end
