//
//  AFSpotCell.h
//  Gowalla-Basic
//
//  Created by Mattt Thompson on 10/11/01.
//  Copyright 2010 Mattt Thompson. All rights reserved.
//

#import "AFImageLoadingCell.h"


@interface AFSpotCell : AFImageLoadingCell {
	UIImageView * visitedCheckmarkImageView;
	BOOL visited;
}

@property(nonatomic, assign, getter = hasVisited) BOOL visited;

@end
