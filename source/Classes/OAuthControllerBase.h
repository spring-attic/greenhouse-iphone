//
//  OAuthControllerBase.h
//  Greenhouse
//
//  Created by Roy Clarkson on 8/27/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthManager.h"


@interface OAuthControllerBase : NSObject <UIAlertViewDelegate> { }

@property (nonatomic, retain) OADataFetcher *dataFetcher;
@property (nonatomic, assign) BOOL fetchingData;

@end
