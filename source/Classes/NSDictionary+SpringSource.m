//
//  NSDictionary+SpringSource.m
//  Greenhouse
//
//  Created by Roy Clarkson on 6/28/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "NSDictionary+SpringSource.h"


@implementation NSDictionary (NSDictionary_SpringSource)

- (NSString *)stringForKey:(id)aKey {
		
	NSString *s;
	
	@try {
		NSObject *o = [self objectForKey:aKey];
		
		if (o == nil || o == [NSNull null]) {
			s = nil;
		}
		else {
			s = [NSString stringWithString:(NSString *)o];
		}
	}
	@catch (NSException * e) {
		s = nil;
	}
	@finally { 
		return s;
	}
}

@end
