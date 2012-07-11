//
//  NSDictionary+Helpers.h
//  Greenhouse
//
//  Created by Roy Clarkson on 6/28/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (NSDictionary_Helpers)

- (NSString *)stringForKey:(id)aKey;
- (NSString *)stringByReplacingPercentEscapesForKey:(id)aKey usingEncoding:(NSStringEncoding)encoding;
- (NSInteger)integerForKey:(id)aKey;
- (double)doubleForKey:(id)aKey;
- (BOOL)boolForKey:(id)aKey;
- (NSDate *)dateWithMillisecondsSince1970ForKey:(id)aKey;
//- (NSDate *)localDateWithMillisecondsSince1970ForKey:(id)aKey;
- (NSURL *)urlForKey:(id)aKey;

@end
