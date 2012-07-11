//
//  ActivityIndicatorTableViewCell.m
//  Greenhouse
//
//  Created by Roy Clarkson on 9/24/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "ActivityIndicatorTableViewCell.h"


@interface ActivityIndicatorTableViewCell()

@property (nonatomic, retain) UIActivityIndicatorView *activityIndicatorView;

@end


@implementation ActivityIndicatorTableViewCell

@synthesize activityIndicatorView = _activityIndicatorView;

- (void)startAnimating
{
	// hold on to reference for existing accessory view;
	_accessoryViewRef = self.accessoryView;
	
	// insert the spinner in its place and begin animating
	self.accessoryView = _activityIndicatorView;
	[_activityIndicatorView startAnimating];
}

- (void)stopAnimating
{
	[_activityIndicatorView stopAnimating];
	
	// replace the accessory view
	self.accessoryView = _accessoryViewRef;
}


#pragma mark -
#pragma mark UITableViewCell methods

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) 
	{
        self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		_activityIndicatorView.hidesWhenStopped = YES;
    }
	
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated 
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[_activityIndicatorView release];
	
    [super dealloc];
}


@end
