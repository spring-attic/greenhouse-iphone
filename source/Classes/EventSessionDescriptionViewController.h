//
//  EventSessionDescriptionViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/26/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventSession.h"


@interface EventSessionDescriptionViewController : UIViewController <DataViewDelegate>
{

}

@property (nonatomic, retain) EventSession *session;
@property (nonatomic, retain) IBOutlet UITextView *textViewDescription;

- (void)refreshView;
- (void)fetchData;

@end
