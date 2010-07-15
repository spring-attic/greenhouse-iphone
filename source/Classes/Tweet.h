//
//  Tweet.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/15/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Tweet : NSObject {

}

@property (nonatomic, assign) NSInteger tweetId;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, retain) NSDate *createdAt;
@property (nonatomic, copy) NSString *fromUser;
@property (nonatomic, copy) NSString *profileImageUrl;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *languageCode;
@property (nonatomic, copy) NSString *source;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
