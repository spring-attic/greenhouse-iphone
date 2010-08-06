//
//  TweetTableViewCell.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/23/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "TweetTableViewCell.h"


@interface TweetTableViewCell()

@property (nonatomic, retain) UILabel *labelUser;
@property (nonatomic, retain) UILabel *labelText;
@property (nonatomic, retain) UILabel *labelTime;
@property (nonatomic, retain) UIImageView *imageViewProfile;

@end


@implementation TweetTableViewCell

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

- (void)setTweet:(Tweet *)aTweet
{
	[tweet release];
	tweet = [aTweet retain];
	
	self.imageViewProfile.image = aTweet.profileImage;
	self.labelUser.text = aTweet.fromUser;
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MMM-d h:mm a"];
	self.labelTime.text = [dateFormatter stringFromDate:aTweet.createdAt];
	[dateFormatter release];
	
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
		[imageViewProfile release];
		
		CGFloat xVal = CGRectGetMaxX(imageViewProfile.frame) + 7.0f;
		
		frame = CGRectMake(xVal, 
						   5.0f, 
						   150.0f, 
						   15.0f);
		self.labelUser = [[UILabel alloc] initWithFrame:frame];
		labelUser.font = [UIFont boldSystemFontOfSize:13.0f];
		[self.contentView addSubview:labelUser];
		[labelUser release];
				
		frame = CGRectMake(xVal, 
						   CGRectGetMaxY(labelUser.frame) + 2.0f, 
						   self.frame.size.width - (xVal + 5.0f), 
						   40.0f);
		self.labelText = [[UILabel alloc] initWithFrame:frame];
		labelText.font = [UIFont systemFontOfSize:13.0f];
		labelText.numberOfLines = 0;
		labelText.lineBreakMode = UILineBreakModeWordWrap;
		[self.contentView addSubview:labelText];
		[labelText release];
		
		xVal = CGRectGetMaxX(labelUser.frame) + 10.0f;
		
		frame = CGRectMake(xVal, 
						   5.0f, 
						   self.frame.size.width - (xVal + 5.0f), 
						   15.0f);
		self.labelTime = [[UILabel alloc] initWithFrame:frame];
		labelTime.font = [UIFont boldSystemFontOfSize:11.0f];
		labelTime.textAlignment = UITextAlignmentRight;
		[self.contentView addSubview:labelTime];
		[labelTime release];		
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
	[labelUser release];
	[labelText release];
	[labelTime release];
	[imageViewProfile release];
	[tweet release];
	
    [super dealloc];
}

@end
