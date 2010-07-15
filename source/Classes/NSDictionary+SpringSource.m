//
//  NSDictionary+SpringSource.m
//  Greenhouse
//
//  Created by Roy Clarkson on 6/28/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "NSDictionary+SpringSource.h"


@implementation NSDictionary (NSDictionary_SpringSource)

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
	@catch (NSException * e) 
	{
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
		d = 0.0f;
	}
	@finally 
	{ 
		return d;
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
		date = nil;
	}
	@finally 
	{
		return date;
	}
}


@end
