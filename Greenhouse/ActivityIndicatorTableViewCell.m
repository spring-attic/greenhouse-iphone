//
//  Copyright 2010-2012 the original author or authors.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//
//  ActivityIndicatorTableViewCell.m
//  Greenhouse
//
//  Created by Roy Clarkson on 9/24/10.
//

#import "ActivityIndicatorTableViewCell.h"


@interface ActivityIndicatorTableViewCell()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

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

@end
