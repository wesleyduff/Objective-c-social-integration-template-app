//
//  PassportViewController.h
//  Gowalla-Basic
//
//  Created by Mattt Thompson on 10/07/01.
//  Copyright 2010 Mattt Thompson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;
@class EGOImageView;

@interface PassportViewController : UITableViewController {
	User * user;
	NSArray * checkIns;
	
	IBOutlet UIActivityIndicatorView * loadingActivityIndicatorView;
	IBOutlet UILabel * nameLabel;
	IBOutlet UILabel * hometownLabel;
	IBOutlet EGOImageView * imageView;
}

@property (nonatomic, retain) User * user;
@property (nonatomic, retain) NSArray * checkIns;

- (id)initWithGowallaUser:(User *)someUser;

@end
