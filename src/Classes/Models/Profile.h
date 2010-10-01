//
//  Profile.h
//  Greenhouse
//
//  Created by Roy Clarkson on 6/11/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebDataModelObject.h"


@interface Profile : WebDataModelObject { }

@property (nonatomic, assign) NSUInteger accountId;
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, retain) NSURL *imageUrl;

+ (Profile *)profileWithDictionary:(NSDictionary *)dictionary;

@end
