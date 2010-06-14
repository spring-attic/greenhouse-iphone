//
//  Person.h
//  Greenhouse
//
//  Created by Roy Clarkson on 6/11/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Person : NSObject 
{

@private
	NSUInteger _personId;
	NSUInteger _version;
	NSString *_firstName;
	NSString *_lastName;
	NSString *_emailAddress;
}

@property (nonatomic, assign) NSUInteger personId;
@property (nonatomic, assign) NSUInteger version;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *emailAddress;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
