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
//  NSDictionary+Helpers.m
//  Greenhouse
//
//  Created by Roy Clarkson on 6/28/10.
//

#import "NSDictionary+Helpers.h"


@implementation NSDictionary (NSDictionary_Helpers)

- (NSString *)stringForKey:(id)aKey 
{		
	NSString *s;
	
	@try 
	{
		NSObject *o = [self objectForKey:aKey];
		
		if (o == nil || o == [NSNull null]) 
		{
			s = nil;
		}
		else 
		{
			if ([o isKindOfClass:[NSString class]])
			{
				s = (NSString *)o;
			}			
			else if ([o isKindOfClass:[NSNumber class]])
			{
				s = [(NSNumber *)o stringValue];
			}
		}
	}
	@catch (NSException *e) 
	{
		DLog(@"Caught %@%@", [e name], [e reason]);
		s = nil;
	}
	@finally 
	{ 
		return s;
	}
}

- (NSString *)stringByReplacingPercentEscapesForKey:(id)aKey usingEncoding:(NSStringEncoding)encoding
{		
	NSString *s;
	
	@try 
	{
		NSObject *o = [self objectForKey:aKey];
		
		if (o == nil || o == [NSNull null]) 
		{
			s = nil;
		}
		else 
		{
			s = [[NSString stringWithString:(NSString *)o] stringByReplacingPercentEscapesUsingEncoding:encoding];
		}
	}
	@catch (NSException *e) 
	{
		DLog(@"Caught %@%@", [e name], [e reason]);
		s = nil;
	}
	@finally 
	{ 
		return s;
	}
}

- (NSInteger)integerForKey:(id)aKey 
{	
	NSInteger i;
	
	@try 
	{
		NSObject *o = [self objectForKey:aKey];
		
		if (o == nil || o == [NSNull null]) 
		{
			i = 0;
		}
		else 
		{
			i = [(NSNumber *)o integerValue];
		}
	}
	@catch (NSException *e) 
	{
		DLog(@"Caught %@%@", [e name], [e reason]);
		i = 0;
	}
	@finally 
	{ 
		return i;
	}
}

- (double)doubleForKey:(id)aKey 
{	
	double d;
	
	@try 
	{
		NSObject *o = [self objectForKey:aKey];
		
		if (o == nil || o == [NSNull null]) 
		{
			d = 0.0f;
		}
		else 
		{
			d = [(NSNumber *)o doubleValue];
		}
	}
	@catch (NSException *e) 
	{
		DLog(@"Caught %@%@", [e name], [e reason]);
		d = 0.0f;
	}
	@finally 
	{ 
		return d;
	}
}

- (BOOL)boolForKey:(id)aKey
{
	BOOL b;
	
	@try 
	{
		NSObject *o = [self objectForKey:aKey];
		
		if (o == nil || o == [NSNull null])
		{
			b = NO;
		}
		else 
		{
			b = [(NSNumber *)o boolValue];
		}
	}
	@catch (NSException * e) 
	{
		DLog(@"Caught %@%@", [e name], [e reason]);
		b = NO;
	}
	@finally 
	{
		return b;
	}
}

- (NSDate *)dateWithMillisecondsSince1970ForKey:(id)aKey 
{	
	NSDate *date;
	
	@try 
	{
		double milliseconds = [self doubleForKey:aKey];
		NSTimeInterval unixDate = (milliseconds * .001);
		date = [NSDate dateWithTimeIntervalSince1970:unixDate];
	}
	@catch (NSException *e) 
	{
		DLog(@"Caught %@%@", [e name], [e reason]);
		date = nil;
	}
	@finally 
	{
		return date;
	}
}

- (NSURL *)urlForKey:(id)aKey
{
	NSURL *url;
	
	@try 
	{
		url = [NSURL URLWithString:[self stringByReplacingPercentEscapesForKey:aKey usingEncoding:NSUTF8StringEncoding]];
	}
	@catch (NSException * e) 
	{
		DLog(@"Caught %@%@", [e name], [e reason]);
		url = nil;
	}
	@finally 
	{
		return url;
	}
}


@end
