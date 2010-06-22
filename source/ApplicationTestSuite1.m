//
//  ApplicationTestSuite1.m
//  Greenhouse
//
//  Created by Roy Clarkson on 6/22/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "ApplicationTestSuite1.h"


@implementation ApplicationTestSuite1

- (void) testAppDelegate 
{    
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
}

@end
