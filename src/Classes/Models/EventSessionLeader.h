//
//  EventSessionLeader.h
//  Greenhouse
//
//  Created by Roy Clarkson on 8/11/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebDataModel.h"


@interface EventSessionLeader : NSObject <WebDataModel> { }

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy, readonly) NSString *displayName;

@end
