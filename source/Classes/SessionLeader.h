//
//  SessionLeader.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/21/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebDataModelObject.h"


@interface SessionLeader : WebDataModelObject 
{

}

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;

@end
