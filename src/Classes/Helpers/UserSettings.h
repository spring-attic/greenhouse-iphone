//
//  UserSettings.h
//  Greenhouse
//
//  Created by Roy Clarkson on 8/25/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserSettings : NSObject { }

+ (void)reset;
+ (BOOL)includeLocationInTweet;
+ (void)setIncludeLocationInTweet:(BOOL)boolVal;
+ (NSInteger)dataExpiration;
+ (BOOL)resetAppOnStart;
+ (void)setAppVersion:(NSString *)appVersion;

@end
