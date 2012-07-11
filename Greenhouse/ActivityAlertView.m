//
//  ActivityAlertView.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/12/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "ActivityAlertView.h"


@interface ActivityAlertView()

@property (nonatomic, retain) UIActivityIndicatorView *activityIndicatorView;

@end


@implementation ActivityAlertView

@synthesize activityIndicatorView = _activityIndicatorView;

- (id)initWithActivityMessage:(NSString *)message
{
	return [self initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
}

- (id)initWithTitle:(NSString *)title 
			message:(NSString *)message 
		   delegate:(id)delegate 
  cancelButtonTitle:(NSString *)cancelButtonTitle 
  otherButtonTitles:(NSString *)otherButtonTitles, ...
{
	if ((self = [super initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil]))
	{
		self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		
		CGRect frame = _activityIndicatorView.frame;
		frame.origin.x = 140.0f - (frame.size.width / 2);

		if (message)
		{
			frame.origin.y = 50.0f;
		}
		else 
		{
			frame.origin.y = 15.0f;
		}

		_activityIndicatorView.frame = frame;
		
		[self addSubview:_activityIndicatorView];
	}
	
	return self;
}

- (void)startAnimating
{
	[_activityIndicatorView startAnimating];
	[self show];
}

- (void)stopAnimating
{
	[self dismissWithClickedButtonIndex:0 animated:NO];
	[_activityIndicatorView stopAnimating];
}

#pragma mark -
#pragma mark NSObject methods

- (void)dealloc
{
	[_activityIndicatorView release];
	
	[super dealloc];
}

@end
