//
//  Event.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/8/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Event : NSObject {

}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *description;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
