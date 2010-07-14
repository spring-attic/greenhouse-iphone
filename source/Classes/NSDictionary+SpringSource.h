//
//  NSDictionary+SpringSource.h
//  Greenhouse
//
//  Created by Roy Clarkson on 6/28/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (NSDictionary_SpringSource)

- (NSString *)stringForKey:(id)aKey;
- (NSInteger)integerForKey:(id)aKey;
- (double)doubleForKey:(id)aKey;
- (NSDate *)dateWithMillisecondsSince1970ForKey:(id)aKey;

@end
