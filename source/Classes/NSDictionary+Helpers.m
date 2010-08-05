//
//  NSDictionary+Helpers.m
//  Greenhouse
//
//  Created by Roy Clarkson on 6/28/10.
//  Copyright 2010 VMware. All rights reserved.
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
			s = [NSString stringWithString:(NSString *)o];
		}
	}
	@catch (NSException *e) 
	{
		DLog(@"%@", [e reason]);
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
		DLog(@"%@", [e reason]);
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
		DLog(@"%@", [e reason]);
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
		DLog(@"%@", [e reason]);
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
		DLog(@"%@", [e reason]);
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
		DLog(@"%@", date.description);
	}
	@catch (NSException *e) 
	{
		DLog(@"%@", [e reason]);
		date = nil;
	}
	@finally 
	{
		return date;
	}
}

//- (NSDate *)localDateWithMillisecondsSince1970ForKey:(id)aKey
//{
//	NSDate *date = [self dateWithMillisecondsSince1970ForKey:aKey];
//	DLog(@"GMT: %@", date.description);
//	
//	NSInteger UTCOffset = [[NSTimeZone timeZoneWithAbbreviation:@"GMT"] secondsFromGMTForDate:date];
//	NSInteger LocalOffset = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:date];
//	NSTimeInterval interval = UTCOffset - LocalOffset;
//	
//	date = [NSDate dateWithTimeInterval:interval sinceDate:date];
//	DLog(@"Local: %@", date.description);
//	
//	return date;
//}


@end
