//
//  AFImageLoadingCell.h
//  Gowalla-Basic
//
//  Created by Mattt Thompson on 10/06/29.
//  Copyright 2010 Mattt Thompson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface AFImageLoadingCell : UITableViewCell <EGOImageViewDelegate> {
@private
	EGOImageView * imageView;
}

- (void)setImageURL:(NSURL *)url;

@end
