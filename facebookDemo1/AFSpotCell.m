//
//  AFSpotCell.m
//  Gowalla-Basic
//
//  Created by Mattt Thompson on 10/11/01.
//  Copyright 2010 Mattt Thompson. All rights reserved.
//

#import "AFSpotCell.h"


@implementation AFSpotCell

@synthesize visited;

- (id)initWithStyle:(UITableViewCellStyle)style 
	reuseIdentifier:(NSString *)reuseIdentifier 
{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		self.visited = NO;
		visitedCheckmarkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark-corner_22.png"]];
		[self.contentView addSubview:visitedCheckmarkImageView];
	}
	
	return self;
}
								 
- (void)dealloc {
	[visitedCheckmarkImageView release];
	[super dealloc];
}

- (void)setVisited:(BOOL)hasVisited {
	visited = hasVisited;
	visitedCheckmarkImageView.hidden = ! self.visited;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	visitedCheckmarkImageView.frame = CGRectMake(self.frame.size.width - 22.0f, 0, 22.0f, 23.0f);
}

@end
