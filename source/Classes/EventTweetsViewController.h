//
//  EventTweetsViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/13/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetsViewController.h"
#import "Event.h"


@interface EventTweetsViewController : TweetsViewController <DataViewDelegate>
{

}

@property (nonatomic, retain) Event *event;

- (void)refreshView;
- (void)fetchData;

@end
