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

@property (nonatomic, assign) NSInteger sessionId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, retain) NSDate *startTime;
@property (nonatomic, retain) NSDate *endTime;
@property (nonatomic, retain) NSMutableArray *leaders;
@property (nonatomic, copy) NSString *hashtag;
@property (nonatomic, assign, readonly) NSInteger leaderCount;
@property (nonatomic, copy, readonly) NSString *leaderDisplay;

@end
