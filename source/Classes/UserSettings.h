//
//  UserSettings.h
//  Greenhouse
//
//  Created by Roy Clarkson on 8/25/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserSettings : NSObject {

}

@property (nonatomic, assign) BOOL includeLocationInTweet;

+ (UserSettings *)sharedInstance;

@end
