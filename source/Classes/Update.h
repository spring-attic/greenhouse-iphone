//
//  Update.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/1/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Update : NSObject {

}

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *timestamp;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
