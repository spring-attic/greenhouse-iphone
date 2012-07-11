//
//  VenueRoom.h
//  Greenhouse
//
//  Created by Roy Clarkson on 10/5/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebDataModel.h"


@interface VenueRoom : NSObject <WebDataModel> { }

@property (nonatomic, copy) NSString *roomId;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *venueId;

@end
