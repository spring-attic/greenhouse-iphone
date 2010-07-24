//
//  TweetTableViewCell.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/23/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "TweetTableViewCell.h"


@implementation TweetTableViewCell


#pragma mark -
#pragma mark UITableViewCell methods

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{    
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) 
	{
        // Initialization code
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
    [super dealloc];
}

@end
