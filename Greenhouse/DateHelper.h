//
//  DateHelper.h
//  Greenhouse
//
//  Created by Roy Clarkson on 12/21/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DateHelper : NSObject { }

+ (NSArray *)daysBetweenStartTime:(NSDate *)startTime endTime:(NSDate *)endTime;

@end
