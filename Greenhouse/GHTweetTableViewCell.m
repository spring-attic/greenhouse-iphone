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
//  GHTweetTableViewCell.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/23/10.
//

#import "GHTweetTableViewCell.h"


@interface GHTweetTableViewCell()

@property (nonatomic, strong) UILabel *labelUser;
@property (nonatomic, strong) UILabel *labelText;
@property (nonatomic, strong) UILabel *labelTime;
@property (nonatomic, strong) UIImageView *imageViewProfile;

@end


@implementation GHTweetTableViewCell

@synthesize labelUser;
@synthesize labelText;
@synthesize labelTime;
@synthesize imageViewProfile;
@synthesize tweet;

- (UILabel *)textLabel
{
	return nil;
}

- (UILabel *)detailTextLabel
{
	return nil;
}

- (UIImageView *)imageView
{
	return imageViewProfile;
}

- (void)setTweet:(GHTweet *)aTweet
{
	if (aTweet.profileImage)
	{
		self.imageViewProfile.image = aTweet.profileImage;
	}
	else 
	{
		self.imageViewProfile.image = [UIImage imageNamed:@"t_logo-b.png"];
	}

	self.labelUser.text = aTweet.fromUser;
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MMM d h:mm a"];
	self.labelTime.text = [dateFormatter stringFromDate:aTweet.createdAt];
	self.labelText.text = aTweet.text;
	
	// adjust the height of the label holding the tweet text
	CGSize size = CGSizeMake(self.frame.size.width - (CGRectGetMaxX(imageViewProfile.frame) + 10.0f), 1500.0f);
	CGRect frame = labelText.frame;
	frame.size = [aTweet.text sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
	labelText.frame = frame;
}


#pragma mark -
#pragma mark UITableViewCell methods

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{    
	if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) 
	{
		CGRect frame = CGRectMake(5.0f, 5.0f, 48.0f, 48.0f);
		self.imageViewProfile = [[UIImageView alloc] initWithFrame:frame];
		[self.contentView addSubview:imageViewProfile];
		
		CGFloat xVal = CGRectGetMaxX(imageViewProfile.frame) + 7.0f;
		
		frame = CGRectMake(xVal, 
						   5.0f, 
						   150.0f, 
						   15.0f);
		self.labelUser = [[UILabel alloc] initWithFrame:frame];
		labelUser.font = [UIFont boldSystemFontOfSize:13.0f];
		[self.contentView addSubview:labelUser];
				
		frame = CGRectMake(xVal, 
						   CGRectGetMaxY(labelUser.frame) + 2.0f, 
						   self.frame.size.width - (xVal + 5.0f), 
						   40.0f);
		self.labelText = [[UILabel alloc] initWithFrame:frame];
		labelText.font = [UIFont systemFontOfSize:13.0f];
		labelText.numberOfLines = 0;
		labelText.lineBreakMode = UILineBreakModeWordWrap;
		[self.contentView addSubview:labelText];
		
		xVal = CGRectGetMaxX(labelUser.frame) + 10.0f;
		
		frame = CGRectMake(xVal, 
						   5.0f, 
						   self.frame.size.width - (xVal + 5.0f), 
						   15.0f);
		self.labelTime = [[UILabel alloc] initWithFrame:frame];
		labelTime.font = [UIFont boldSystemFontOfSize:11.0f];
		labelTime.textAlignment = UITextAlignmentRight;
		[self.contentView addSubview:labelTime];	
    }
	
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated 
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
