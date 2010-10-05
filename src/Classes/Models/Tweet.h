//
//  Tweet.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/15/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebDataModel.h"


@interface Tweet : NSObject <WebDataModel> { }

@property (nonatomic, copy) NSString *tweetId;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, retain) NSDate *createdAt;
@property (nonatomic, copy) NSString *fromUser;
@property (nonatomic, copy) NSString *profileImageUrl;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *languageCode;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, retain) UIImage *profileImage;

@end
