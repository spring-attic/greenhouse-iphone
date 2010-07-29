//
//  EventDescriptionViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/22/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"


@interface EventDescriptionViewController : UIViewController <DataViewDelegate>
{

}

@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) IBOutlet UITextView *textView;

- (void)refreshView;
- (void)fetchData;

@end
