//
//  AppSettings.h
//  Greenhouse
//
//  Created by Roy Clarkson on 6/11/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AppSettings : NSObject { }

+ (NSString *)documentsDirectory;
+ (NSString *)appVersion;

@end
