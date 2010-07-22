//
//  Update.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/1/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebDataModelObject.h"


@interface Update : WebDataModelObject 
{

}

@property (nonatomic, copy) NSString *text;
@property (nonatomic, retain) NSDate *timestamp;

@end
