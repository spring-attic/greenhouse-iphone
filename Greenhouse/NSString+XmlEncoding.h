//
//  NSString+XmlEncoding.h
//  Greenhouse
//
//  Created by Roy Clarkson on 9/23/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (NSString_XmlEncoding)

- (NSString *)stringBySimpleXmlEncoding;
- (NSString *)stringBySimpleXmlDecoding;

@end
