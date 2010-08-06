//
//  EventSession.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/21/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebDataModelObject.h"


@interface EventSession : WebDataModelObject 
{

}

@property (nonatomic, assign) NSInteger number;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) NSDate *startTime;
@property (nonatomic, retain) NSDate *endTime;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, retain) NSMutableArray *leaders;
@property (nonatomic, copy) NSString *hashtag;
@property (nonatomic, assign) BOOL isFavorite;
@property (nonatomic, assign) double rating;
@property (nonatomic, assign, readonly) NSInteger leaderCount;
@property (nonatomic, copy, readonly) NSString *leaderDisplay;

@end
